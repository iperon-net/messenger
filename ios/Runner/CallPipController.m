#import "CallPipController.h"

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <WebRTC/WebRTC.h>

// Аспект мини-окна PiP (width:height). Кадр вписываем в холст этого аспекта с
// чёрными полями (letterbox) — так окно становится ниже/меньше вытянутого
// портрета камеры. 3:4 = умеренно короче 9:16, с небольшими боковыми полями.
static const CGFloat kPipAspectW = 3.0;
static const CGFloat kPipAspectH = 4.0;

// Forward-declaration публичного API flutter_webrtc — чтобы не тянуть header пода
// (его видимость из таргета Runner не гарантирована). Класс линкуется в
// приложение самим плагином; здесь мы лишь объявляем нужные селекторы.
// См. common/darwin/Classes/FlutterWebRTCPlugin.h в пакете flutter_webrtc.
@interface FlutterWebRTCPlugin : NSObject
+ (instancetype)sharedSingleton;
- (RTCMediaStreamTrack *)remoteTrackForId:(NSString *)trackId;
- (RTCMediaStreamTrack *)trackForId:(NSString *)trackId peerConnectionId:(NSString *)peerConnectionId;
@end

#pragma mark - Рендерер: RTCVideoFrame → AVSampleBufferDisplayLayer

/// `id<RTCVideoRenderer>`, который конвертирует кадры удалённого трека в
/// `CMSampleBuffer` и складывает в свой `AVSampleBufferDisplayLayer`. Логика
/// конвертации перенесена из flutter_webrtc `FlutterRTCVideoPlatformView.m`
/// (RTCCVPixelBuffer — быстрый путь; I420 — фолбэк через RTCYUVHelper → 32BGRA).
///
/// [frozenForPlaceholder] — когда собеседник выключил камеру, живых кадров нет и в
/// слое застыл бы последний кадр. Тогда включаем этот флаг (живые кадры
/// игнорируем) и один раз рисуем плейсхолдер ([showPlaceholderImage:]).
@interface CallPipRenderer : NSObject <RTCVideoRenderer>
@property(nonatomic, strong, readonly) AVSampleBufferDisplayLayer *displayLayer;
@property(nonatomic, assign) BOOL frozenForPlaceholder;
- (void)showPlaceholderImage:(nullable UIImage *)image;
@end

@implementation CallPipRenderer {
  dispatch_queue_t _queue;
  int _lastWidth;
  int _lastHeight;
  CIContext *_ciContext;
}

- (instancetype)init {
  if (self = [super init]) {
    _displayLayer = [[AVSampleBufferDisplayLayer alloc] init];
    _displayLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _queue = dispatch_queue_create("net.iperon.messenger.pip.samplebuffer", DISPATCH_QUEUE_SERIAL);
    _ciContext = [CIContext contextWithOptions:nil];
  }
  return self;
}

- (void)setSize:(CGSize)size {
}

- (void)renderFrame:(nullable RTCVideoFrame *)frame {
  if (!frame) return;
  if (self.frozenForPlaceholder) return;  // камера собеседника выключена — показываем плейсхолдер

  CVPixelBufferRef source = NULL;
  if ([frame.buffer isKindOfClass:[RTCCVPixelBuffer class]]) {
    source = ((RTCCVPixelBuffer *)frame.buffer).pixelBuffer;
    if (source) CVPixelBufferRetain(source);
  } else {
    source = [self bgraPixelBufferFromI420:frame];
  }
  if (!source) return;

  // Вписываем кадр в холст фиксированного аспекта (letterbox) — так мини-окно PiP
  // становится ниже/меньше; заодно применяем поворот кадра.
  CVPixelBufferRef canvas = [self letterboxedFromSource:source rotation:frame.rotation];
  CVPixelBufferRelease(source);
  if (!canvas) return;
  _lastWidth = (int)CVPixelBufferGetWidth(canvas);
  _lastHeight = (int)CVPixelBufferGetHeight(canvas);
  [self enqueuePixelBuffer:canvas];
  CVPixelBufferRelease(canvas);
}

/// Композитит кадр [source] в холст аспекта kPipAspectW:kPipAspectH с чёрными
/// полями (aspect-fit), применяя поворот кадра. Возвращает новый BGRA-пиксельбуфер
/// (владение у вызывающего). Core Image единообразно работает с NV12 и BGRA.
- (CVPixelBufferRef)letterboxedFromSource:(CVPixelBufferRef)source rotation:(RTCVideoRotation)rotation {
  CIImage *image = [CIImage imageWithCVPixelBuffer:source];
  CGImagePropertyOrientation orientation = kCGImagePropertyOrientationUp;
  switch (rotation) {
    case RTCVideoRotation_90:
      orientation = kCGImagePropertyOrientationRight;
      break;
    case RTCVideoRotation_180:
      orientation = kCGImagePropertyOrientationDown;
      break;
    case RTCVideoRotation_270:
      orientation = kCGImagePropertyOrientationLeft;
      break;
    default:
      break;
  }
  image = [image imageByApplyingCGOrientation:orientation];
  CGRect extent = image.extent;
  CGFloat srcW = extent.size.width;
  CGFloat srcH = extent.size.height;
  if (srcW < 1 || srcH < 1) return NULL;

  // Холст: высоту берём по большей стороне, ширину — по целевому аспекту, но не
  // меньше исходной ширины (чтобы не терять качество).
  CGFloat targetAspect = kPipAspectW / kPipAspectH;  // width/height
  int canvasH = (int)lround(srcH);
  int canvasW = (int)lround(canvasH * targetAspect);
  if (canvasW < srcW) {
    canvasW = (int)lround(srcW);
    canvasH = (int)lround(canvasW / targetAspect);
  }

  CGFloat scale = MIN(canvasW / srcW, canvasH / srcH);
  CGFloat drawW = srcW * scale;
  CGFloat drawH = srcH * scale;
  CGFloat dx = (canvasW - drawW) / 2.0;
  CGFloat dy = (canvasH - drawH) / 2.0;

  CIImage *scaled = [image imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
  // После scale extent.origin тоже масштабируется — сдвигаем в (dx,dy) от нуля.
  scaled = [scaled imageByApplyingTransform:CGAffineTransformMakeTranslation(dx - extent.origin.x * scale,
                                                                             dy - extent.origin.y * scale)];
  CIImage *black = [[CIImage imageWithColor:[CIColor colorWithRed:0 green:0 blue:0]]
      imageByCroppingToRect:CGRectMake(0, 0, canvasW, canvasH)];
  CIImage *composited = [scaled imageByCompositingOverImage:black];

  CVPixelBufferRef canvas = NULL;
  NSDictionary *attrs = @{
    (id)kCVPixelBufferIOSurfacePropertiesKey : @{},
    (id)kCVPixelBufferCGImageCompatibilityKey : @YES,
    (id)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
  };
  if (CVPixelBufferCreate(kCFAllocatorDefault, canvasW, canvasH, kCVPixelFormatType_32BGRA,
                          (__bridge CFDictionaryRef)attrs, &canvas) != kCVReturnSuccess || !canvas) {
    return NULL;
  }
  [_ciContext render:composited toCVPixelBuffer:canvas];
  return canvas;
}

- (void)enqueuePixelBuffer:(CVPixelBufferRef)pixelBuffer {
  CMSampleBufferRef sampleBuffer = [self sampleBufferFromPixelBuffer:pixelBuffer];
  if (!sampleBuffer) return;
  dispatch_async(_queue, ^{
    if (@available(iOS 14.0, *)) {
      if ([self->_displayLayer requiresFlushToResumeDecoding]) {
        [self->_displayLayer flushAndRemoveImage];
      }
    }
    [self->_displayLayer enqueueSampleBuffer:sampleBuffer];
    CFRelease(sampleBuffer);
  });
}

- (void)showPlaceholderImage:(nullable UIImage *)image {
  self.frozenForPlaceholder = YES;
  CVPixelBufferRef pixelBuffer = [self placeholderPixelBufferWithImage:image];
  if (!pixelBuffer) return;
  [self enqueuePixelBuffer:pixelBuffer];
  CVPixelBufferRelease(pixelBuffer);
}

- (CVPixelBufferRef)placeholderPixelBufferWithImage:(nullable UIImage *)image {
  // По умолчанию (кадров ещё не было) — тот же аспект, что у letterbox-холста,
  // чтобы форма окна не прыгала. После первого кадра _lastWidth/_lastHeight уже
  // равны размерам холста.
  int w = _lastWidth > 0 ? _lastWidth : 720;
  int h = _lastHeight > 0 ? _lastHeight : (int)lround(720.0 * kPipAspectH / kPipAspectW);
  CVPixelBufferRef pb = NULL;
  NSDictionary *attrs = @{
    (id)kCVPixelBufferCGImageCompatibilityKey : @YES,
    (id)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
    (id)kCVPixelBufferIOSurfacePropertiesKey : @{},
  };
  if (CVPixelBufferCreate(kCFAllocatorDefault, w, h, kCVPixelFormatType_32BGRA,
                          (__bridge CFDictionaryRef)attrs, &pb) != kCVReturnSuccess || !pb) {
    return NULL;
  }
  CVPixelBufferLockBaseAddress(pb, 0);
  void *base = CVPixelBufferGetBaseAddress(pb);
  size_t bpr = CVPixelBufferGetBytesPerRow(pb);
  CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
  CGContextRef ctx = CGBitmapContextCreate(base, w, h, 8, bpr, cs,
                                           kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
  // Тёмный фон (как экран звонка).
  CGContextSetRGBFillColor(ctx, 0.11, 0.11, 0.12, 1.0);
  CGContextFillRect(ctx, CGRectMake(0, 0, w, h));
  // Аватар по центру в круге (если передан). Флипаем по вертикали — CG-контекст
  // над пиксельбуфером имеет origin снизу, иначе картинка рисуется вверх ногами.
  // Круг центрирован по высоте, поэтому после флипа остаётся на месте.
  if (image && image.CGImage) {
    CGFloat side = MIN(w, h) * 0.4;
    CGRect r = CGRectMake((w - side) / 2.0, (h - side) / 2.0, side, side);
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, h);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextAddEllipseInRect(ctx, r);
    CGContextClip(ctx);
    CGContextDrawImage(ctx, r, image.CGImage);
    CGContextRestoreGState(ctx);
  }
  CGContextRelease(ctx);
  CGColorSpaceRelease(cs);
  CVPixelBufferUnlockBaseAddress(pb, 0);
  return pb;
}

- (CVPixelBufferRef)bgraPixelBufferFromI420:(RTCVideoFrame *)frame {
  CVPixelBufferRef out = NULL;
  NSDictionary *attrs = @{
    (id)kCVPixelBufferCGImageCompatibilityKey : @YES,
    (id)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
    (id)kCVPixelBufferIOSurfacePropertiesKey : @{},
  };
  CVPixelBufferCreate(kCFAllocatorDefault, frame.width, frame.height, kCVPixelFormatType_32BGRA,
                      (__bridge CFDictionaryRef)attrs, &out);
  if (!out) return NULL;

  id<RTCI420Buffer> i420 = [frame.buffer toI420];
  CVPixelBufferLockBaseAddress(out, 0);
  uint8_t *dst = CVPixelBufferGetBaseAddress(out);
  const size_t bytesPerRow = CVPixelBufferGetBytesPerRow(out);
  [RTCYUVHelper I420ToARGB:i420.dataY
                srcStrideY:i420.strideY
                      srcU:i420.dataU
                srcStrideU:i420.strideU
                      srcV:i420.dataV
                srcStrideV:i420.strideV
                   dstARGB:dst
             dstStrideARGB:(int)bytesPerRow
                     width:i420.width
                    height:i420.height];
  CVPixelBufferUnlockBaseAddress(out, 0);
  return out;
}

- (CMSampleBufferRef)sampleBufferFromPixelBuffer:(CVPixelBufferRef)pixelBuffer {
  CMSampleBufferRef sampleBuffer = NULL;
  CMVideoFormatDescriptionRef formatDesc = NULL;
  if (CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, &formatDesc) != noErr) {
    return NULL;
  }
  CMSampleTimingInfo timing = kCMTimingInfoInvalid;
  OSStatus err = CMSampleBufferCreateReadyWithImageBuffer(kCFAllocatorDefault, pixelBuffer, formatDesc,
                                                          &timing, &sampleBuffer);
  if (formatDesc) CFRelease(formatDesc);
  if (err != noErr) return NULL;

  if (sampleBuffer) {
    CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, YES);
    if (attachments && CFArrayGetCount(attachments) > 0) {
      CFMutableDictionaryRef dict = (CFMutableDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
      if (dict) CFDictionarySetValue(dict, kCMSampleAttachmentKey_DisplayImmediately, kCFBooleanTrue);
    }
  }
  return sampleBuffer;
}

@end

#pragma mark - Контроллер PiP

API_AVAILABLE(ios(15.0))
@interface CallPipController () <AVPictureInPictureControllerDelegate, AVPictureInPictureSampleBufferPlaybackDelegate>
@end

@implementation CallPipController {
  FlutterMethodChannel *_channel;
  CallPipRenderer *_renderer;
  RTCVideoTrack *_track;
  AVPictureInPictureController *_pip;
  // Невидимая host-view в окне: слой должен присутствовать «на экране», иначе
  // авто-старт PiP при сворачивании система может не выполнить.
  UIView *_hostView;
  // Идёт разворот PiP обратно в приложение (тап по кнопке разворота). Отличает
  // «развернули» от «закрыли крестиком» в didStopPictureInPicture.
  BOOL _restoring;
}

+ (instancetype)shared {
  static CallPipController *shared;
  static dispatch_once_t once;
  dispatch_once(&once, ^{ shared = [[CallPipController alloc] init]; });
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
  if ([call.method isEqualToString:@"isSupported"]) {
    BOOL supported = NO;
    if (@available(iOS 15.0, *)) supported = [AVPictureInPictureController isPictureInPictureSupported];
    result(@(supported));
    return;
  }
  if ([call.method isEqualToString:@"prepare"]) {
    NSString *trackId = call.arguments[@"trackId"];
    if (@available(iOS 15.0, *)) [self prepareWithTrackId:trackId];
    result(nil);
    return;
  }
  if ([call.method isEqualToString:@"showPlaceholder"]) {
    UIImage *image = nil;
    id data = call.arguments[@"image"];
    if ([data isKindOfClass:[FlutterStandardTypedData class]]) {
      image = [UIImage imageWithData:((FlutterStandardTypedData *)data).data];
    }
    [_renderer showPlaceholderImage:image];
    result(nil);
    return;
  }
  if ([call.method isEqualToString:@"hidePlaceholder"]) {
    _renderer.frozenForPlaceholder = NO;  // живые кадры снова пойдут в слой
    result(nil);
    return;
  }
  if ([call.method isEqualToString:@"teardown"]) {
    [self teardown];
    result(nil);
    return;
  }
  result(FlutterMethodNotImplemented);
}

- (void)prepareWithTrackId:(NSString *)trackId API_AVAILABLE(ios(15.0)) {
  if (![AVPictureInPictureController isPictureInPictureSupported]) return;
  if (trackId.length == 0) return;

  RTCVideoTrack *track = [self remoteVideoTrackForId:trackId];
  if (!track) return;
  if (_track == track && _pip != nil) return;  // уже готово к этому треку

  [self teardown];

  _renderer = [[CallPipRenderer alloc] init];
  _track = track;
  [_track addRenderer:_renderer];

  // Невидимая host-view в окне — чтобы слой считался «на экране» для авто-старта.
  UIWindow *window = [self keyWindow];
  _hostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
  _hostView.userInteractionEnabled = NO;
  _hostView.alpha = 0.01;
  _renderer.displayLayer.frame = _hostView.bounds;
  [_hostView.layer addSublayer:_renderer.displayLayer];
  [window addSubview:_hostView];

  AVPictureInPictureControllerContentSource *source =
      [[AVPictureInPictureControllerContentSource alloc] initWithSampleBufferDisplayLayer:_renderer.displayLayer
                                                                        playbackDelegate:self];
  _pip = [[AVPictureInPictureController alloc] initWithContentSource:source];
  _pip.delegate = self;
  if (@available(iOS 14.2, *)) {
    _pip.canStartPictureInPictureAutomaticallyFromInline = YES;
  }
}

- (void)teardown {
  if (_track && _renderer) [_track removeRenderer:_renderer];
  _track = nil;
  if (_pip) {
    // Снимаем делегата ДО остановки: didStop не должен принять это за «закрыли
    // крестиком» и повторно завершить звонок (см. pipClosed). Останавливаем PiP
    // явно, чтобы окно закрылось при завершении звонка (в т.ч. собеседником).
    _pip.delegate = nil;
    if (@available(iOS 15.0, *)) {
      if (_pip.isPictureInPictureActive) [_pip stopPictureInPicture];
    }
    _pip = nil;
  }
  [_renderer.displayLayer removeFromSuperlayer];
  _renderer = nil;
  [_hostView removeFromSuperview];
  _hostView = nil;
  _restoring = NO;
}

- (RTCVideoTrack *)remoteVideoTrackForId:(NSString *)trackId {
  Class cls = NSClassFromString(@"FlutterWebRTCPlugin");
  if (!cls) return nil;
  id plugin = [cls sharedSingleton];
  RTCMediaStreamTrack *track = nil;
  if ([plugin respondsToSelector:@selector(remoteTrackForId:)]) {
    track = [plugin remoteTrackForId:trackId];
  }
  if (!track && [plugin respondsToSelector:@selector(trackForId:peerConnectionId:)]) {
    track = [plugin trackForId:trackId peerConnectionId:nil];
  }
  return [track isKindOfClass:[RTCVideoTrack class]] ? (RTCVideoTrack *)track : nil;
}

- (UIWindow *)keyWindow {
  for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
    if ([scene isKindOfClass:[UIWindowScene class]] &&
        scene.activationState == UISceneActivationStateForegroundActive) {
      for (UIWindow *w in ((UIWindowScene *)scene).windows) {
        if (w.isKeyWindow) return w;
      }
    }
  }
  return UIApplication.sharedApplication.delegate.window;
}

#pragma mark - AVPictureInPictureControllerDelegate

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController
    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler
    API_AVAILABLE(ios(15.0)) {
  // Пользователь развернул PiP обратно в приложение (не закрыл крестиком).
  _restoring = YES;
  completionHandler(YES);
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
    API_AVAILABLE(ios(15.0)) {
  BOOL wasRestoring = _restoring;
  _restoring = NO;
  // PiP остановился без разворота в приложение — значит закрыт крестиком.
  // Система лишь убирает окно; звонок завершаем сами (как на Android).
  if (!wasRestoring) {
    [_channel invokeMethod:@"pipClosed" arguments:nil];
  }
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController
    failedToStartPictureInPictureWithError:(NSError *)error API_AVAILABLE(ios(15.0)) {
  NSLog(@"[CallPip] failed to start PiP: %@", error);
}

#pragma mark - AVPictureInPictureSampleBufferPlaybackDelegate

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController
                        setPlaying:(BOOL)playing API_AVAILABLE(ios(15.0)) {
}

- (CMTimeRange)pictureInPictureControllerTimeRangeForPlayback:(AVPictureInPictureController *)pictureInPictureController
    API_AVAILABLE(ios(15.0)) {
  // «Живой» поток без длительности/перемотки.
  return CMTimeRangeMake(kCMTimeNegativeInfinity, kCMTimePositiveInfinity);
}

- (BOOL)pictureInPictureControllerIsPlaybackPaused:(AVPictureInPictureController *)pictureInPictureController
    API_AVAILABLE(ios(15.0)) {
  return NO;
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController
         didTransitionToRenderSize:(CMVideoDimensions)newRenderSize API_AVAILABLE(ios(15.0)) {
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController
                    skipByInterval:(CMTime)skipInterval
                 completionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(15.0)) {
  completionHandler();
}

@end
