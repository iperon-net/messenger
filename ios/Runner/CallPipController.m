#import "CallPipController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebRTC/WebRTC.h>

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
/// конвертации перенесена 1:1 из flutter_webrtc `FlutterRTCVideoPlatformView.m`
/// (RTCCVPixelBuffer — быстрый путь; I420 — фолбэк через RTCYUVHelper → 32BGRA).
@interface CallPipRenderer : NSObject <RTCVideoRenderer>
@property(nonatomic, strong, readonly) AVSampleBufferDisplayLayer *displayLayer;
@end

@implementation CallPipRenderer {
  dispatch_queue_t _queue;
}

- (instancetype)init {
  if (self = [super init]) {
    _displayLayer = [[AVSampleBufferDisplayLayer alloc] init];
    _displayLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _queue = dispatch_queue_create("net.iperon.messenger.pip.samplebuffer", DISPATCH_QUEUE_SERIAL);
  }
  return self;
}

- (void)setSize:(CGSize)size {
}

- (void)renderFrame:(nullable RTCVideoFrame *)frame {
  if (!frame) return;

  CVPixelBufferRef pixelBuffer = NULL;
  if ([frame.buffer isKindOfClass:[RTCCVPixelBuffer class]]) {
    // Быстрый путь: аппаратно декодированный кадр уже CVPixelBuffer.
    pixelBuffer = ((RTCCVPixelBuffer *)frame.buffer).pixelBuffer;
    if (pixelBuffer) CVPixelBufferRetain(pixelBuffer);
  } else {
    pixelBuffer = [self bgraPixelBufferFromI420:frame];
  }
  if (!pixelBuffer) return;

  CMSampleBufferRef sampleBuffer = [self sampleBufferFromPixelBuffer:pixelBuffer];
  CVPixelBufferRelease(pixelBuffer);
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
    if (@available(iOS 15.0, *)) {
      [self prepareWithTrackId:trackId];
    }
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

  // Пересоздаём аккуратно: снимаем старый рендерер/трек, но по возможности
  // переиспользуем слой и контроллер, если trackId тот же.
  RTCVideoTrack *track = [self remoteVideoTrackForId:trackId];
  if (!track) return;
  if (_track == track && _pip != nil) return; // уже готово к этому треку

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
  if (@available(iOS 15.0, *)) {
    _pip.delegate = nil;
    _pip = nil;
  }
  [_renderer.displayLayer removeFromSuperlayer];
  _renderer = nil;
  [_hostView removeFromSuperview];
  _hostView = nil;
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
    if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
      for (UIWindow *w in ((UIWindowScene *)scene).windows) {
        if (w.isKeyWindow) return w;
      }
    }
  }
  return UIApplication.sharedApplication.delegate.window;
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
