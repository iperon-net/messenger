#import "CallPipController.h"

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebRTC/WebRTC.h>
#import <stdatomic.h>

// Публичный API flutter_webrtc (common/darwin/Classes/FlutterWebRTCPlugin.h) —
// объявлен протоколом, чтобы не тянуть header пода в таргет Runner и не ссылаться
// на символ класса при линковке: класс резолвим в рантайме (NSClassFromString).
@protocol CallPipWebRTCPlugin <NSObject>
+ (id)sharedSingleton;
- (RTCMediaStreamTrack *)remoteTrackForId:(NSString *)trackId;
// Текущий захват камеры (пересоздаётся на каждое включение камеры).
- (RTCCameraVideoCapturer *)videoCapturer;
@end

#pragma mark - Рендерер: RTCVideoFrame → AVSampleBufferDisplayLayer

/// `id<RTCVideoRenderer>` на удалённом треке: кадр → `CVPixelBuffer` →
/// `CMSampleBuffer` → свой `AVSampleBufferDisplayLayer` (логика конвертации — как в
/// flutter_webrtc `FlutterRTCVideoPlatformView.m`).
///
/// Потокобезопасность (именно здесь раньше ловили краши):
///  • `renderFrame:` зовётся на потоке декодера WebRTC; слой и очередь — сильные
///    ссылки самого рендерера, блоки держат `self` сильно — висячих указателей нет;
///  • [invalidate] (main) атомарно гасит приём кадров ДО `removeRenderer:`, а уже
///    поставленные в очередь блоки после этого ничего не кладут в слой;
///  • ничего GPU-шного (Metal/Core Image): в фоне это запрещено системой.
@interface CallPipRenderer : NSObject <RTCVideoRenderer>
- (instancetype)initWithLayer:(AVSampleBufferDisplayLayer *)layer
                     onFormat:(void (^)(int width, int height, RTCVideoRotation rotation))onFormat;
- (void)invalidate;
@end

@implementation CallPipRenderer {
  AVSampleBufferDisplayLayer *_layer;
  dispatch_queue_t _queue;
  void (^_onFormat)(int, int, RTCVideoRotation);
  atomic_bool _active;
  // Сколько кадров ждёт в очереди слоя — при отставании дропаем, а не копим.
  atomic_int _pending;
  // Последний формат и пул буферов для I420-пути — только на потоке рендера.
  int _lastWidth;
  int _lastHeight;
  RTCVideoRotation _lastRotation;
  CVPixelBufferPoolRef _pool;
  int _poolWidth;
  int _poolHeight;
}

- (instancetype)initWithLayer:(AVSampleBufferDisplayLayer *)layer
                     onFormat:(void (^)(int, int, RTCVideoRotation))onFormat {
  if (self = [super init]) {
    _layer = layer;
    _onFormat = [onFormat copy];
    _queue = dispatch_queue_create("net.iperon.messenger.pip.samplebuffer", DISPATCH_QUEUE_SERIAL);
    atomic_init(&_active, true);
    atomic_init(&_pending, 0);
    _lastRotation = RTCVideoRotation_0;
  }
  return self;
}

- (void)dealloc {
  if (_pool) CVPixelBufferPoolRelease(_pool);
}

- (void)invalidate {
  atomic_store(&_active, false);
  AVSampleBufferDisplayLayer *layer = _layer;
  // Через ту же очередь — строго после уже поставленных блоков.
  dispatch_async(_queue, ^{
    [layer flushAndRemoveImage];
  });
}

- (void)setSize:(CGSize)size {
}

- (void)renderFrame:(nullable RTCVideoFrame *)frame {
  if (!frame || !atomic_load(&_active)) return;
  if (atomic_load(&_pending) >= 3) return;  // слой не успевает — пропускаем кадр

  const int width = (int)frame.width;
  const int height = (int)frame.height;
  if (width <= 0 || height <= 0) return;
  if (width != _lastWidth || height != _lastHeight || frame.rotation != _lastRotation) {
    _lastWidth = width;
    _lastHeight = height;
    _lastRotation = frame.rotation;
    if (_onFormat) _onFormat(width, height, frame.rotation);
  }

  CVPixelBufferRef pixelBuffer = NULL;
  if ([frame.buffer isKindOfClass:[RTCCVPixelBuffer class]] &&
      ![(RTCCVPixelBuffer *)frame.buffer requiresCropping]) {
    pixelBuffer = ((RTCCVPixelBuffer *)frame.buffer).pixelBuffer;
    if (pixelBuffer) CVPixelBufferRetain(pixelBuffer);
  } else {
    pixelBuffer = [self bgraPixelBufferFromFrame:frame];
  }
  if (!pixelBuffer) return;
  CMSampleBufferRef sampleBuffer = [self sampleBufferFromPixelBuffer:pixelBuffer];
  CVPixelBufferRelease(pixelBuffer);
  if (!sampleBuffer) return;

  AVSampleBufferDisplayLayer *layer = _layer;
  atomic_fetch_add(&_pending, 1);
  dispatch_async(_queue, ^{
    atomic_fetch_sub(&self->_pending, 1);
    if (atomic_load(&self->_active)) {
      // После ухода в фон/прерывания слой может встать в failed — сбрасываем.
      if (layer.status == AVQueuedSampleBufferRenderingStatusFailed) {
        [layer flush];
      } else if (@available(iOS 14.0, *)) {
        if (layer.requiresFlushToResumeDecoding) [layer flush];
      }
      [layer enqueueSampleBuffer:sampleBuffer];
    }
    CFRelease(sampleBuffer);
  });
}

/// Фолбэк для не-CVPixelBuffer кадров (I420 и т.п.): CPU-конвертация в 32BGRA
/// через RTCYUVHelper в буфер из пула.
- (CVPixelBufferRef)bgraPixelBufferFromFrame:(RTCVideoFrame *)frame {
  id<RTCI420Buffer> i420 = [frame.buffer toI420];
  const int width = i420.width;
  const int height = i420.height;
  if (width <= 0 || height <= 0) return NULL;

  if (!_pool || _poolWidth != width || _poolHeight != height) {
    if (_pool) CVPixelBufferPoolRelease(_pool);
    _pool = NULL;
    NSDictionary *attrs = @{
      (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
      (id)kCVPixelBufferWidthKey : @(width),
      (id)kCVPixelBufferHeightKey : @(height),
      (id)kCVPixelBufferIOSurfacePropertiesKey : @{},
    };
    if (CVPixelBufferPoolCreate(kCFAllocatorDefault, NULL, (__bridge CFDictionaryRef)attrs, &_pool) != kCVReturnSuccess) {
      _pool = NULL;
      return NULL;
    }
    _poolWidth = width;
    _poolHeight = height;
  }

  CVPixelBufferRef out = NULL;
  if (CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, _pool, &out) != kCVReturnSuccess || !out) {
    return NULL;
  }
  CVPixelBufferLockBaseAddress(out, 0);
  [RTCYUVHelper I420ToARGB:i420.dataY
                srcStrideY:i420.strideY
                      srcU:i420.dataU
                srcStrideU:i420.strideU
                      srcV:i420.dataV
                srcStrideV:i420.strideV
                   dstARGB:CVPixelBufferGetBaseAddress(out)
             dstStrideARGB:(int)CVPixelBufferGetBytesPerRow(out)
                     width:width
                    height:height];
  CVPixelBufferUnlockBaseAddress(out, 0);
  return out;
}

- (CMSampleBufferRef)sampleBufferFromPixelBuffer:(CVPixelBufferRef)pixelBuffer {
  CMVideoFormatDescriptionRef formatDesc = NULL;
  if (CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, &formatDesc) != noErr) {
    return NULL;
  }
  CMSampleTimingInfo timing = kCMTimingInfoInvalid;
  CMSampleBufferRef sampleBuffer = NULL;
  OSStatus err =
      CMSampleBufferCreateReadyWithImageBuffer(kCFAllocatorDefault, pixelBuffer, formatDesc, &timing, &sampleBuffer);
  CFRelease(formatDesc);
  if (err != noErr || !sampleBuffer) return NULL;

  CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, YES);
  if (attachments && CFArrayGetCount(attachments) > 0) {
    CFMutableDictionaryRef dict = (CFMutableDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
    if (dict) CFDictionarySetValue(dict, kCMSampleAttachmentKey_DisplayImmediately, kCFBooleanTrue);
  }
  return sampleBuffer;
}

@end

#pragma mark - Содержимое мини-окна

/// View, чей слой — `AVSampleBufferDisplayLayer`.
@interface CallPipVideoView : UIView
@property(nonatomic, readonly) AVSampleBufferDisplayLayer *displayLayer;
@end

@implementation CallPipVideoView
+ (Class)layerClass {
  return [AVSampleBufferDisplayLayer class];
}
- (AVSampleBufferDisplayLayer *)displayLayer {
  return (AVSampleBufferDisplayLayer *)self.layer;
}
@end

/// Содержимое PiP-окна: видео собеседника (с учётом поворота кадра) и поверх него
/// плейсхолдер — аватар (или инициалы) и имя, когда видео нет.
@interface CallPipContentView : UIView
@property(nonatomic, readonly) AVSampleBufferDisplayLayer *videoLayer;
@property(nonatomic, assign) RTCVideoRotation rotation;
@property(nonatomic, assign) BOOL placeholderVisible;
- (void)setPeerName:(nullable NSString *)name image:(nullable UIImage *)image;
@end

@implementation CallPipContentView {
  CallPipVideoView *_videoView;
  UIView *_placeholder;
  UIImageView *_avatar;
  UILabel *_initials;
  UILabel *_name;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = UIColor.blackColor;
    self.clipsToBounds = YES;

    _videoView = [[CallPipVideoView alloc] initWithFrame:self.bounds];
    _videoView.displayLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _videoView.userInteractionEnabled = NO;
    [self addSubview:_videoView];

    _placeholder = [[UIView alloc] initWithFrame:self.bounds];
    _placeholder.backgroundColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.12 alpha:1.0];
    [self addSubview:_placeholder];

    _avatar = [[UIImageView alloc] init];
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    _avatar.clipsToBounds = YES;
    _avatar.backgroundColor = [UIColor colorWithRed:0.35 green:0.40 blue:0.50 alpha:1.0];
    [_placeholder addSubview:_avatar];

    _initials = [[UILabel alloc] init];
    _initials.textColor = UIColor.whiteColor;
    _initials.textAlignment = NSTextAlignmentCenter;
    [_avatar addSubview:_initials];

    _name = [[UILabel alloc] init];
    _name.textColor = UIColor.whiteColor;
    _name.textAlignment = NSTextAlignmentCenter;
    _name.lineBreakMode = NSLineBreakByTruncatingTail;
    [_placeholder addSubview:_name];

    _placeholderVisible = YES;
  }
  return self;
}

- (AVSampleBufferDisplayLayer *)videoLayer {
  return _videoView.displayLayer;
}

- (void)setRotation:(RTCVideoRotation)rotation {
  if (_rotation == rotation) return;
  _rotation = rotation;
  [self setNeedsLayout];
}

- (void)setPlaceholderVisible:(BOOL)visible {
  _placeholderVisible = visible;
  _placeholder.hidden = !visible;
}

- (void)setPeerName:(nullable NSString *)name image:(nullable UIImage *)image {
  _avatar.image = image;
  _initials.hidden = image != nil;
  _initials.text = [CallPipContentView initialsFromName:name];
  _name.text = name;
  [self setNeedsLayout];
}

+ (NSString *)initialsFromName:(nullable NSString *)name {
  NSMutableString *out = [NSMutableString string];
  NSArray<NSString *> *parts =
      [name componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
  for (NSString *part in parts) {
    if (part.length == 0) continue;
    NSRange first = [part rangeOfComposedCharacterSequenceAtIndex:0];
    [out appendString:[[part substringWithRange:first] uppercaseString]];
    if (out.length >= 2) break;
  }
  return out;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  const CGRect bounds = self.bounds;
  const CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));

  // Кадр повёрнут (CVO): слой рисует его «как есть», поэтому кладём view
  // с переставленными сторонами и поворачиваем трансформом — после поворота она
  // ровно накрывает окно (aspect fill).
  const BOOL sideways = _rotation == RTCVideoRotation_90 || _rotation == RTCVideoRotation_270;
  _videoView.transform = CGAffineTransformIdentity;
  _videoView.bounds = sideways ? CGRectMake(0, 0, bounds.size.height, bounds.size.width) : bounds;
  _videoView.center = center;
  _videoView.transform = CGAffineTransformMakeRotation((CGFloat)_rotation * M_PI / 180.0);

  _placeholder.frame = bounds;
  const CGFloat minSide = MIN(bounds.size.width, bounds.size.height);
  const CGFloat side = floor(minSide * 0.45);
  const CGFloat nameHeight = ceil(MAX(12.0, minSide * 0.1) * 1.3);
  const CGFloat gap = floor(minSide * 0.06);
  const CGFloat top = floor((bounds.size.height - side - gap - nameHeight) / 2.0);
  _avatar.frame = CGRectMake(floor((bounds.size.width - side) / 2.0), top, side, side);
  _avatar.layer.cornerRadius = side / 2.0;
  _initials.frame = _avatar.bounds;
  _initials.font = [UIFont systemFontOfSize:side * 0.4 weight:UIFontWeightSemibold];
  _name.font = [UIFont systemFontOfSize:MAX(12.0, minSide * 0.1) weight:UIFontWeightMedium];
  _name.frame = CGRectMake(8, CGRectGetMaxY(_avatar.frame) + gap, bounds.size.width - 16, nameHeight);
}

@end

#pragma mark - Контроллер PiP

API_AVAILABLE(ios(15.0))
@interface CallPipController () <AVPictureInPictureControllerDelegate>
@end

@implementation CallPipController {
  FlutterMethodChannel *_channel;
  // AVPictureInPictureController / AVPictureInPictureVideoCallViewController
  // (iOS 15+) — как id, чтобы не размечать ivar'ы availability.
  id _pip;
  id _pipViewController;
  // Остановленный при [disable] контроллер держим до didStop (или до следующего
  // enable/disable), чтобы не освобождать его посреди анимации закрытия.
  id _retiringPip;
  CallPipContentView *_content;
  CallPipRenderer *_renderer;
  RTCVideoTrack *_track;
  BOOL _videoOff;
  NSString *_peerName;
  UIImage *_peerImage;
  BOOL _observing;
}

+ (instancetype)shared {
  static CallPipController *shared;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    shared = [[CallPipController alloc] init];
  });
  return shared;
}

- (void)registerWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
  _channel = [FlutterMethodChannel methodChannelWithName:@"net.iperon.messenger/call_pip_ios"
                                         binaryMessenger:messenger];
  __weak typeof(self) weakSelf = self;
  [_channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
    [weakSelf handleMethodCall:call result:result];
  }];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSDictionary *args = [call.arguments isKindOfClass:[NSDictionary class]] ? call.arguments : @{};
  if ([call.method isEqualToString:@"enable"]) {
    BOOL ok = NO;
    if (@available(iOS 15.0, *)) ok = [self enable];
    result(@(ok));
  } else if ([call.method isEqualToString:@"disable"]) {
    [self disable];
    result(nil);
  } else if ([call.method isEqualToString:@"setTrack"]) {
    id trackId = args[@"trackId"];
    result(@([self setTrackId:[trackId isKindOfClass:[NSString class]] ? trackId : nil]));
  } else if ([call.method isEqualToString:@"keepCameraInBackground"]) {
    result(@([self keepCameraInBackground]));
  } else if ([call.method isEqualToString:@"setVideoOff"]) {
    _videoOff = [args[@"off"] boolValue];
    [self updatePlaceholder];
    result(nil);
  } else if ([call.method isEqualToString:@"setPeer"]) {
    id name = args[@"name"];
    id image = args[@"image"];
    _peerName = [name isKindOfClass:[NSString class]] ? name : nil;
    _peerImage = [image isKindOfClass:[FlutterStandardTypedData class]]
                     ? [UIImage imageWithData:((FlutterStandardTypedData *)image).data]
                     : nil;
    [_content setPeerName:_peerName image:_peerImage];
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

/// Создаёт PiP-контроллер (без трека — видео подключается [setTrackId:]).
/// Идемпотентно. NO — PiP недоступен (ОС/устройство) или нет view-источника.
- (BOOL)enable API_AVAILABLE(ios(15.0)) {
  if (_pip) return YES;
  if (![AVPictureInPictureController isPictureInPictureSupported]) return NO;
  UIView *sourceView = [self sourceView];
  if (!sourceView) return NO;
  _retiringPip = nil;

  AVPictureInPictureVideoCallViewController *vc = [[AVPictureInPictureVideoCallViewController alloc] init];
  vc.preferredContentSize = CGSizeMake(1080, 1920);
  CallPipContentView *content = [[CallPipContentView alloc] initWithFrame:vc.view.bounds];
  content.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [content setPeerName:_peerName image:_peerImage];
  [vc.view addSubview:content];

  AVPictureInPictureControllerContentSource *source =
      [[AVPictureInPictureControllerContentSource alloc] initWithActiveVideoCallSourceView:sourceView
                                                                     contentViewController:vc];
  AVPictureInPictureController *pip = [[AVPictureInPictureController alloc] initWithContentSource:source];
  pip.delegate = self;
  pip.canStartPictureInPictureAutomaticallyFromInline = YES;

  _pip = pip;
  _pipViewController = vc;
  _content = content;
  [self updatePlaceholder];
  [self startObserving];
  [self enableMultitaskingOnSession:[self cameraSession]];
  return YES;
}

/// Полный разбор: сначала отцепляем рендерер от трека, затем закрываем окно.
- (void)disable {
  [self stopObserving];
  [self detachTrack];
  if (_pip) {
    if (@available(iOS 15.0, *)) {
      AVPictureInPictureController *pip = _pip;
      pip.canStartPictureInPictureAutomaticallyFromInline = NO;
      if (pip.isPictureInPictureActive) {
        _retiringPip = pip;
        [pip stopPictureInPicture];
      } else {
        pip.delegate = nil;
      }
    }
  }
  _pip = nil;
  _pipViewController = nil;
  _content = nil;
  _videoOff = NO;
}

/// Подключает видео трека [trackId] (nil — отключает). YES — видео подключено.
- (BOOL)setTrackId:(nullable NSString *)trackId {
  if (trackId.length == 0 || !_content) {
    [self detachTrack];
    return NO;
  }
  RTCVideoTrack *track = [self remoteVideoTrackForId:trackId];
  if (!track) {
    [self detachTrack];
    return NO;
  }
  if (track == _track && _renderer) return YES;
  [self detachTrack];

  __weak typeof(self) weakSelf = self;
  CallPipRenderer *renderer = [[CallPipRenderer alloc]
      initWithLayer:_content.videoLayer
           onFormat:^(int width, int height, RTCVideoRotation rotation) {
             dispatch_async(dispatch_get_main_queue(), ^{
               [weakSelf applyFrameWidth:width height:height rotation:rotation];
             });
           }];
  _renderer = renderer;
  _track = track;
  [track addRenderer:renderer];
  [self updatePlaceholder];
  return YES;
}

- (void)detachTrack {
  CallPipRenderer *renderer = _renderer;
  RTCVideoTrack *track = _track;
  _renderer = nil;
  _track = nil;
  if (renderer) {
    // Сначала гасим приём кадров, потом снимаем с трека — после removeRenderer:
    // WebRTC больше не зовёт renderFrame:, а уже стоящие в очереди блоки no-op.
    [renderer invalidate];
    [track removeRenderer:renderer];
  }
  [self updatePlaceholder];
}

- (void)updatePlaceholder {
  _content.placeholderVisible = _videoOff || !_renderer;
}

- (void)applyFrameWidth:(int)width height:(int)height rotation:(RTCVideoRotation)rotation {
  if (!_content) return;
  _content.rotation = rotation;
  const BOOL sideways = rotation == RTCVideoRotation_90 || rotation == RTCVideoRotation_270;
  if (@available(iOS 15.0, *)) {
    AVPictureInPictureVideoCallViewController *vc = _pipViewController;
    vc.preferredContentSize = sideways ? CGSizeMake(height, width) : CGSizeMake(width, height);
  }
}

- (nullable RTCVideoTrack *)remoteVideoTrackForId:(NSString *)trackId {
  Class cls = NSClassFromString(@"FlutterWebRTCPlugin");
  if (!cls || ![cls respondsToSelector:@selector(sharedSingleton)]) return nil;
  id<CallPipWebRTCPlugin> plugin = [(id)cls sharedSingleton];
  if (![plugin respondsToSelector:@selector(remoteTrackForId:)]) return nil;
  RTCMediaStreamTrack *track = [plugin remoteTrackForId:trackId];
  return [track isKindOfClass:[RTCVideoTrack class]] ? (RTCVideoTrack *)track : nil;
}

/// Источник анимации/авто-старта PiP — корневая view Flutter (экран звонка).
- (nullable UIView *)sourceView {
  UIWindow *fallback = nil;
  for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
    if (![scene isKindOfClass:[UIWindowScene class]]) continue;
    for (UIWindow *window in ((UIWindowScene *)scene).windows) {
      if (window.isKeyWindow && window.rootViewController.view) return window.rootViewController.view;
      if (!fallback && window.rootViewController.view) fallback = window;
    }
  }
  return fallback.rootViewController.view;
}

#pragma mark - Своя камера в фоне (iOS 18+)

// С iOS 18 приложениям с фоновым режимом `voip` разрешён захват камеры в
// многозадачности (PiP) без отдельного entitlement — нужно лишь включить
// `multitaskingCameraAccessEnabled` на сессии захвата. Сессию flutter_webrtc
// пересоздаёт на каждое включение камеры, поэтому флаг ставим при каждом её старте
// (DidStartRunning), плюс страховочно на уходе из активного состояния. Если система
// всё же прервала захват (блокировка экрана, PiP не открылся/закрылся, iOS < 18),
// шлём в Dart `cameraInterrupted` — там камеру глушат, чтобы собеседник видел
// аватар, а не застывший кадр.

- (void)startObserving {
  if (_observing) return;
  _observing = YES;
  NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
  [nc addObserver:self
         selector:@selector(captureSessionDidStartRunning:)
             name:AVCaptureSessionDidStartRunningNotification
           object:nil];
  [nc addObserver:self
         selector:@selector(captureSessionWasInterrupted:)
             name:AVCaptureSessionWasInterruptedNotification
           object:nil];
  [nc addObserver:self selector:@selector(willDeactivate:) name:UIApplicationWillResignActiveNotification object:nil];
  [nc addObserver:self selector:@selector(willDeactivate:) name:UISceneWillDeactivateNotification object:nil];
}

- (void)stopObserving {
  if (!_observing) return;
  _observing = NO;
  NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
  [nc removeObserver:self name:AVCaptureSessionDidStartRunningNotification object:nil];
  [nc removeObserver:self name:AVCaptureSessionWasInterruptedNotification object:nil];
  [nc removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
  [nc removeObserver:self name:UISceneWillDeactivateNotification object:nil];
}

- (void)captureSessionDidStartRunning:(NSNotification *)note {
  AVCaptureSession *session = [note.object isKindOfClass:[AVCaptureSession class]] ? note.object : nil;
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_pip) [self enableMultitaskingOnSession:session];
  });
}

- (void)willDeactivate:(NSNotification *)note {
  if (_pip) [self enableMultitaskingOnSession:[self cameraSession]];
}

- (void)captureSessionWasInterrupted:(NSNotification *)note {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (!self->_pip) return;
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive) return;
    [self->_channel invokeMethod:@"cameraInterrupted" arguments:nil];
  });
}

/// YES — захват камеры разрешено продолжать в фоне (iOS 18+ / voip) и он сейчас
/// идёт. Зовётся из Dart при уходе в фон: NO — камеру надо заглушить.
- (BOOL)keepCameraInBackground {
  AVCaptureSession *session = [self cameraSession];
  if (!_pip || !session) return NO;
  if (![self enableMultitaskingOnSession:session]) return NO;
  return session.isRunning && !session.isInterrupted;
}

- (BOOL)enableMultitaskingOnSession:(nullable AVCaptureSession *)session {
  if (!session) return NO;
  if (@available(iOS 16.0, *)) {
    if (!session.isMultitaskingCameraAccessSupported) return NO;
    if (!session.isMultitaskingCameraAccessEnabled) session.multitaskingCameraAccessEnabled = YES;
    return YES;
  }
  return NO;
}

- (nullable AVCaptureSession *)cameraSession {
  Class cls = NSClassFromString(@"FlutterWebRTCPlugin");
  if (!cls || ![cls respondsToSelector:@selector(sharedSingleton)]) return nil;
  id<CallPipWebRTCPlugin> plugin = [(id)cls sharedSingleton];
  if (![plugin respondsToSelector:@selector(videoCapturer)]) return nil;
  return plugin.videoCapturer.captureSession;
}

#pragma mark - AVPictureInPictureControllerDelegate

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController
    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler
    API_AVAILABLE(ios(15.0)) {
  completionHandler(YES);
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
    API_AVAILABLE(ios(15.0)) {
  if (pictureInPictureController == _retiringPip) {
    pictureInPictureController.delegate = nil;
    _retiringPip = nil;
  }
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController
    failedToStartPictureInPictureWithError:(NSError *)error API_AVAILABLE(ios(15.0)) {
  NSLog(@"[CallPip] failed to start PiP: %@", error);
}

@end
