//
//  SampleHandler.swift
//  BroadcastExtension
//
//  ReplayKit Broadcast Upload Extension для демонстрации экрана в звонке.
//  Захватывает кадры всего экрана и передаёт их основному приложению через
//  unix-сокет в общем App Group-контейнере; на стороне приложения их читает
//  flutter_webrtc (FlutterBroadcastScreenCapturer). Скелет — из примера LiveKit
//  (client-sdk-flutter), адаптирован под App Group `group.net.iperon.messenger`.
//

import ReplayKit
import OSLog

let broadcastLogger = OSLog(subsystem: "net.iperon.messenger", category: "Broadcast")

private enum Constants {
    // App Group ID, общий у Runner и этого расширения (см. entitlements обоих
    // таргетов и ключ RTCAppGroupIdentifier в Info.plist приложения).
    static let appGroupIdentifier = "group.net.iperon.messenger"
}

class SampleHandler: RPBroadcastSampleHandler {

    private var clientConnection: SocketConnection?
    private var uploader: SampleUploader?

    private var frameCount: Int = 0

    var socketFilePath: String {
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupIdentifier)
        return sharedContainer?.appendingPathComponent("rtc_SSFD").path ?? ""
    }

    override init() {
        super.init()
        if let connection = SocketConnection(filePath: socketFilePath) {
            clientConnection = connection
            setupConnection()

            uploader = SampleUploader(connection: connection)
        }
        os_log(.debug, log: broadcastLogger, "%{public}s", socketFilePath)
    }

    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        // Пользователь начал демонстрацию экрана.
        frameCount = 0

        DarwinNotificationCenter.shared.postNotification(.broadcastStarted)
        openConnection()
    }

    override func broadcastPaused() {}

    override func broadcastResumed() {}

    override func broadcastFinished() {
        // Пользователь остановил демонстрацию экрана.
        DarwinNotificationCenter.shared.postNotification(.broadcastStopped)
        clientConnection?.close()
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            uploader?.send(sample: sampleBuffer)
        default:
            break
        }
    }
}

private extension SampleHandler {

    func setupConnection() {
        clientConnection?.didClose = { [weak self] error in
            os_log(.debug, log: broadcastLogger, "client connection did close \(String(describing: error))")

            if let error = error {
                self?.finishBroadcastWithError(error)
            } else {
                // NSError даёт более дружелюбное системное сообщение, чем Error.
                let screenSharingStopped = 10001
                let customError = NSError(domain: RPRecordingErrorDomain, code: screenSharingStopped, userInfo: [NSLocalizedDescriptionKey: "Демонстрация экрана остановлена"])
                self?.finishBroadcastWithError(customError)
            }
        }
    }

    func openConnection() {
        let queue = DispatchQueue(label: "broadcast.connectTimer")
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: .milliseconds(100), leeway: .milliseconds(500))
        timer.setEventHandler { [weak self] in
            guard self?.clientConnection?.open() == true else {
                return
            }

            timer.cancel()
        }

        timer.resume()
    }
}
