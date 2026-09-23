#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

/// iOS Picture-in-Picture для видеозвонка: показывает видео СОБЕСЕДНИКА в системном
/// мини-окне, когда приложение сворачивают во время видеозвонка.
///
/// Как это работает (см. docs/ios_pip_plan.md):
///  1. по trackId достаём нативный удалённый RTCVideoTrack через публичный
///     `+[FlutterWebRTCPlugin sharedSingleton]` / `-remoteTrackForId:`
///     (форк flutter_webrtc не нужен);
///  2. вешаем на трек свой `id<RTCVideoRenderer>`, который гонит кадры в
///     `AVSampleBufferDisplayLayer`;
///  3. слой отдаём в `AVPictureInPictureController` (content source, iOS 15+);
///  4. `canStartPictureInPictureAutomaticallyFromInline = YES` — систему просим
///     сама открывать PiP при сворачивании и закрывать при возврате.
///
/// Драйвится из Dart по каналу `net.iperon.messenger/call_pip_ios`
/// (см. lib/call_pip_ios.dart), регистрируется из AppDelegate.
@interface CallPipController : NSObject

+ (instancetype)shared;

/// Регистрирует MethodChannel на переданном мессенджере движка. Зовётся один раз
/// из AppDelegate после регистрации плагинов.
- (void)registerWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;

@end

NS_ASSUME_NONNULL_END
