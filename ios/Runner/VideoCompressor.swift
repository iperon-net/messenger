import AVFoundation
import Flutter
import UIKit

/// Сжатие видео для чата перед отправкой (сервер видит только шифротекст и
/// пережать сам не может — см. lib/chats/video_prepare.dart). Канал
/// `net.iperon.messenger/video`:
/// - `info` {path, thumb?, thumbSide} → {width, height, durationMs, bitrate}
///   (размеры — как видео показывается, с учётом поворота) и кадр-превью JPEG
///   в `thumb`;
/// - `compress` {id, path, out, shortSide, bitrate} → путь к MP4 (H.264 +
///   AAC). AVAssetReader/AVAssetWriter, а не AVAssetExportSession: у пресетов
///   экспорта нельзя задать битрейт. Прогресс — вызовом `progress` {id,
///   progress} обратно в Dart;
/// - `cancel` {id}.
final class VideoCompressor {
  static let shared = VideoCompressor()

  private var channel: FlutterMethodChannel?
  private var jobs: [String: Job] = [:]
  private let queue = DispatchQueue(label: "net.iperon.messenger.video", qos: .userInitiated)

  func attach(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "net.iperon.messenger/video", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    self.channel = channel
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "info":
      guard let path = args["path"] as? String else {
        return result(FlutterError(code: "args", message: "path", details: nil))
      }
      let thumb = args["thumb"] as? String
      let thumbSide = args["thumbSide"] as? Int ?? 320
      queue.async {
        let info = Self.info(path: path, thumb: thumb, thumbSide: thumbSide)
        DispatchQueue.main.async { result(info) }
      }
    case "compress":
      guard let id = args["id"] as? String, let path = args["path"] as? String, let out = args["out"] as? String else {
        return result(FlutterError(code: "args", message: "id/path/out", details: nil))
      }
      let job = Job(
        source: URL(fileURLWithPath: path),
        output: URL(fileURLWithPath: out),
        shortSide: args["shortSide"] as? Int ?? 0,
        bitrate: args["bitrate"] as? Int ?? 2_500_000
      )
      jobs[id] = job
      job.onProgress = { [weak self] progress in
        DispatchQueue.main.async {
          self?.channel?.invokeMethod("progress", arguments: ["id": id, "progress": progress])
        }
      }
      job.run { [weak self] error in
        DispatchQueue.main.async {
          self?.jobs[id] = nil
          if let error = error as? Job.Failure, error == .cancelled {
            result(FlutterError(code: "cancelled", message: nil, details: nil))
          } else if let error {
            result(FlutterError(code: "compress", message: error.localizedDescription, details: nil))
          } else {
            result(out)
          }
        }
      }
    case "cancel":
      if let id = args["id"] as? String { jobs[id]?.cancel() }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Размеры (с поворотом), длительность, битрейт и кадр-превью.
  private static func info(path: String, thumb: String?, thumbSide: Int) -> [String: Any]? {
    let asset = AVURLAsset(url: URL(fileURLWithPath: path))
    guard let track = asset.tracks(withMediaType: .video).first else { return nil }
    let size = displaySize(track.naturalSize, track.preferredTransform)
    var info: [String: Any] = [
      "width": Int(size.width.rounded()),
      "height": Int(size.height.rounded()),
      "durationMs": Int((CMTimeGetSeconds(asset.duration) * 1000).rounded()),
      "bitrate": Int(track.estimatedDataRate),
    ]
    if let thumb {
      let generator = AVAssetImageGenerator(asset: asset)
      generator.appliesPreferredTrackTransform = true
      generator.maximumSize = CGSize(width: thumbSide, height: thumbSide)
      if let image = try? generator.copyCGImage(at: .zero, actualTime: nil),
         let data = UIImage(cgImage: image).jpegData(compressionQuality: 0.75),
         (try? data.write(to: URL(fileURLWithPath: thumb))) != nil {
        info["thumb"] = thumb
      }
    }
    return info
  }

  static func displaySize(_ natural: CGSize, _ transform: CGAffineTransform) -> CGSize {
    let rect = CGRect(origin: .zero, size: natural).applying(transform)
    return CGSize(width: abs(rect.width), height: abs(rect.height))
  }

  /// Одно сжатие: чтение исходника и запись H.264 нужного размера/битрейта.
  final class Job {
    enum Failure: Error, Equatable { case noVideo, cancelled, reader, writer }

    let source: URL
    let output: URL
    let shortSide: Int
    let bitrate: Int
    var onProgress: ((Double) -> Void)?

    private let lock = NSLock()
    private var cancelled = false
    private var reader: AVAssetReader?
    private var writer: AVAssetWriter?

    init(source: URL, output: URL, shortSide: Int, bitrate: Int) {
      self.source = source
      self.output = output
      self.shortSide = shortSide
      self.bitrate = bitrate
    }

    var isCancelled: Bool {
      lock.lock()
      defer { lock.unlock() }
      return cancelled
    }

    func cancel() {
      lock.lock()
      cancelled = true
      lock.unlock()
    }

    func run(completion: @escaping (Error?) -> Void) {
      do {
        try start(completion: completion)
      } catch {
        completion(error)
      }
    }

    private func start(completion: @escaping (Error?) -> Void) throws {
      let asset = AVURLAsset(url: source)
      guard let videoTrack = asset.tracks(withMediaType: .video).first else { throw Failure.noVideo }
      let audioTrack = asset.tracks(withMediaType: .audio).first
      let duration = max(CMTimeGetSeconds(asset.duration), 0.001)

      // Размер в исходной (до поворота) ориентации: короткая сторона →
      // shortSide, не увеличиваем; кодеку нужны чётные стороны.
      let natural = videoTrack.naturalSize
      let shortest = min(natural.width, natural.height)
      let scale = shortSide > 0 && shortest > 0 ? min(1, CGFloat(shortSide) / shortest) : 1
      func even(_ v: CGFloat) -> Int { max(2, Int((v * scale).rounded()) & ~1) }
      let width = even(natural.width)
      let height = even(natural.height)

      try? FileManager.default.removeItem(at: output)
      let reader = try AVAssetReader(asset: asset)
      let writer = try AVAssetWriter(outputURL: output, fileType: .mp4)
      writer.shouldOptimizeForNetworkUse = true
      self.reader = reader
      self.writer = writer

      let videoOut = AVAssetReaderTrackOutput(
        track: videoTrack,
        outputSettings: [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
      )
      videoOut.alwaysCopiesSampleData = false
      reader.add(videoOut)
      let videoIn = AVAssetWriterInput(mediaType: .video, outputSettings: [
        AVVideoCodecKey: AVVideoCodecType.h264,
        AVVideoWidthKey: width,
        AVVideoHeightKey: height,
        AVVideoCompressionPropertiesKey: [
          AVVideoAverageBitRateKey: bitrate,
          AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
          AVVideoMaxKeyFrameIntervalDurationKey: 2,
        ],
      ])
      // Поворот не «запекаем» — пишем как в исходнике, плееры его учитывают.
      videoIn.transform = videoTrack.preferredTransform
      videoIn.expectsMediaDataInRealTime = false
      writer.add(videoIn)

      // Звук: PCM стерео 44,1 кГц из исходника (моно/многоканальный сводятся) →
      // AAC 128 кбит/с.
      var stereo = AudioChannelLayout()
      stereo.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo
      let layout = Data(bytes: &stereo, count: MemoryLayout<AudioChannelLayout>.size)
      var audioOut: AVAssetReaderTrackOutput?
      var audioIn: AVAssetWriterInput?
      if let audioTrack {
        let output = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: [
          AVFormatIDKey: kAudioFormatLinearPCM,
          AVSampleRateKey: 44_100,
          AVNumberOfChannelsKey: 2,
          AVChannelLayoutKey: layout,
          AVLinearPCMBitDepthKey: 16,
          AVLinearPCMIsFloatKey: false,
          AVLinearPCMIsBigEndianKey: false,
          AVLinearPCMIsNonInterleaved: false,
        ])
        let input = AVAssetWriterInput(mediaType: .audio, outputSettings: [
          AVFormatIDKey: kAudioFormatMPEG4AAC,
          AVSampleRateKey: 44_100,
          AVNumberOfChannelsKey: 2,
          AVChannelLayoutKey: layout,
          AVEncoderBitRateKey: 128_000,
        ])
        input.expectsMediaDataInRealTime = false
        if reader.canAdd(output), writer.canAdd(input) {
          reader.add(output)
          writer.add(input)
          audioOut = output
          audioIn = input
        }
      }

      guard reader.startReading() else { throw reader.error ?? Failure.reader }
      guard writer.startWriting() else { throw writer.error ?? Failure.writer }
      writer.startSession(atSourceTime: .zero)

      let group = DispatchGroup()
      var lastReported = -1.0

      func pump(_ input: AVAssetWriterInput, _ output: AVAssetReaderTrackOutput, queue: DispatchQueue, video: Bool) {
        group.enter()
        var finished = false
        input.requestMediaDataWhenReady(on: queue) { [weak self] in
          guard let self, !finished else { return }
          while input.isReadyForMoreMediaData {
            if self.isCancelled || reader.status != .reading {
              finished = true
              input.markAsFinished()
              group.leave()
              return
            }
            guard let sample = output.copyNextSampleBuffer() else {
              finished = true
              input.markAsFinished()
              group.leave()
              return
            }
            if video {
              let time = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sample))
              let progress = min(1, max(0, time / duration))
              if progress - lastReported >= 0.01 {
                lastReported = progress
                self.onProgress?(progress)
              }
            }
            if !input.append(sample) {
              finished = true
              input.markAsFinished()
              group.leave()
              return
            }
          }
        }
      }

      pump(videoIn, videoOut, queue: DispatchQueue(label: "net.iperon.messenger.video.v"), video: true)
      if let audioIn, let audioOut {
        pump(audioIn, audioOut, queue: DispatchQueue(label: "net.iperon.messenger.video.a"), video: false)
      }

      group.notify(queue: DispatchQueue.global(qos: .userInitiated)) { [weak self] in
        guard let self else { return }
        if self.isCancelled {
          reader.cancelReading()
          writer.cancelWriting()
          try? FileManager.default.removeItem(at: self.output)
          return completion(Failure.cancelled)
        }
        if reader.status == .failed || writer.status == .failed {
          reader.cancelReading()
          writer.cancelWriting()
          try? FileManager.default.removeItem(at: self.output)
          return completion(reader.error ?? writer.error ?? Failure.writer)
        }
        writer.finishWriting {
          completion(writer.status == .completed ? nil : (writer.error ?? Failure.writer))
        }
      }
    }
  }
}
