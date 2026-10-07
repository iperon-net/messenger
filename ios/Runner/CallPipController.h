#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

/// iOS Picture-in-Picture видеозвонка: системное мини-окно с видео СОБЕСЕДНИКА
/// (или его аватаром, если камера выключена), когда приложение сворачивают во время
/// видеозвонка — как FaceTime.
///
/// Устройство:
///  • окно — `AVPictureInPictureVideoCallViewController` (API Apple именно для
///    звонков, iOS 15+) с источником `activeVideoCallSourceView` = корневая view
///    Flutter; `canStartPictureInPictureAutomaticallyFromInline` — система сама
///    открывает окно при сворачивании и закрывает при возврате;
///  • внутри окна — нативная view: `AVSampleBufferDisplayLayer` с видео и
///    плейсхолдер (аватар/инициалы + имя) поверх него;
///  • кадры берём с нативного удалённого `RTCVideoTrack` через публичный
///    `+[FlutterWebRTCPlugin sharedSingleton]` / `-remoteTrackForId:` (без форка
///    плагина) — вешаем на трек свой `id<RTCVideoRenderer>`.
///
/// Своя камера в фоне (iOS 18+, право даёт фоновый режим `voip`): на сессии
/// захвата flutter_webrtc включаем `multitaskingCameraAccessEnabled` — собеседник
/// продолжает видеть нас, пока открыто мини-окно. Если система всё же прервала
/// захват — шлём в Dart `cameraInterrupted` (там камеру глушат).
///
/// Только CPU-путь (без Metal/Core Image): в фоне GPU-работа приложению запрещена.
///
/// Драйвится из Dart по каналу `net.iperon.messenger/call_pip_ios`
/// (lib/call_pip_ios.dart): `enable`/`disable`, `setTrack`, `setVideoOff`,
/// `setPeer`, `keepCameraInBackground`; обратно — `cameraInterrupted`.
/// Регистрируется из AppDelegate.
@interface CallPipController : NSObject

+ (instancetype)shared;

/// Регистрирует MethodChannel на переданном мессенджере движка. Зовётся один раз
/// из AppDelegate после регистрации плагинов.
- (void)registerWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;

@end

NS_ASSUME_NONNULL_END
