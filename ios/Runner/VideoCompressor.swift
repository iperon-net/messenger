import AVFoundation
import VideoToolbox
#if os(iOS)
import Flutter
import UIKit
#else
// Тот же файл собирается и в macOS-приложение (ссылкой из macos/Runner).
import FlutterMacOS
import AppKit
#endif

/// Сжатие видео для чата перед отправкой (сервер видит только шифротекст и
/// пережать сам не может — см. lib/chats/video_prepare.dart). Канал
/// `net.iperon.messenger/video`:
/// - `info` {path, thumb?, thumbSide, thumbAtMs?} → {width, height, durationMs,
///   bitrate, fps} (размеры — как видео показывается, с учётом поворота) и
///   кадр-превью JPEG (момент `thumbAtMs`, по умолчанию первый кадр) в `thumb`;
/// - `frames` {path, count, side, prefix} → пути JPEG `<prefix>_<i>.jpg` —
///   кадры, равномерно по длине видео (лента редактора; не вышло — пустая строка);
/// - `compress` {id, path, out, shortSide, bitrate, codec, maxFps, startMs?,
///   endMs?, mute?, crop?, rotation?} → путь к MP4 (`codec`: `hevc` | `h264`, + AAC).
///   AVAssetReader/AVAssetWriter, а не AVAssetExportSession: у пресетов
///   экспорта нельзя задать битрейт. Кадры чаще `maxFps` прореживаются;
///   `startMs`..`endMs` — обрезка (`endMs` 0 — до конца), `mute` — без звука,
///   `crop` [left, top, width, height] долями показываемого кадра и `rotation`
///   (по часовой, 0/90/180/270) — кадрирование и поворот, «запекаются» в кадр
///   через AVVideoComposition.
///   Прогресс — вызовом `progress` {id, progress} обратно в Dart. Кодек не
///   поддерживается — ошибка `unsupported` (Dart откатится на H.264);
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
      let thumbAtMs = args["thumbAtMs"] as? Int ?? 0
      Task {
        let video = try? await Video.load(URL(fileURLWithPath: path))
        // Кадр-превью — синхронно, на своей очереди (не в пуле Swift Concurrency).
        queue.async {
          let info = video.map { Self.info($0, thumb: thumb, thumbSide: thumbSide, thumbAtMs: thumbAtMs) }
          DispatchQueue.main.async { result(info) }
        }
      }
    case "frames":
      guard let path = args["path"] as? String, let prefix = args["prefix"] as? String else {
        return result(FlutterError(code: "args", message: "path/prefix", details: nil))
      }
      let count = args["count"] as? Int ?? 10
      let side = args["side"] as? Int ?? 160
      Task {
        let video = try? await Video.load(URL(fileURLWithPath: path))
        queue.async {
          let frames = video.map { Self.frames($0, count: count, side: side, prefix: prefix) } ?? []
          DispatchQueue.main.async { result(frames) }
        }
      }
    case "compress":
      guard let id = args["id"] as? String, let path = args["path"] as? String, let out = args["out"] as? String else {
        return result(FlutterError(code: "args", message: "id/path/out", details: nil))
      }
      let job = Job(
        source: URL(fileURLWithPath: path),
        output: URL(fileURLWithPath: out),
        shortSide: args["shortSide"] as? Int ?? 0,
        bitrate: args["bitrate"] as? Int ?? 2_500_000,
        hevc: (args["codec"] as? String) == "hevc",
        maxFps: args["maxFps"] as? Int ?? 0,
        startMs: args["startMs"] as? Int ?? 0,
        endMs: args["endMs"] as? Int ?? 0,
        mute: args["mute"] as? Bool ?? false,
        crop: (args["crop"] as? [NSNumber])?.map { CGFloat(truncating: $0) },
        rotation: args["rotation"] as? Int ?? 0
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
          } else if let error = error as? Job.Failure, error == .unsupported {
            result(FlutterError(code: "unsupported", message: nil, details: nil))
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

  /// Свойства видео, загруженные заранее асинхронно: синхронные
  /// `AVAsset.tracks` / `duration` и `AVAssetTrack.naturalSize` /
  /// `preferredTransform` / … устарели (macOS 13, iOS 16) — они блокируют поток
  /// до загрузки. `load` — с iOS 15 / macOS 12.
  struct Video {
    let asset: AVURLAsset
    let track: AVAssetTrack
    /// Первая звуковая дорожка (только если просили).
    let audio: AVAssetTrack?
    let duration: CMTime
    let naturalSize: CGSize
    let preferredTransform: CGAffineTransform
    let nominalFrameRate: Float
    let estimatedDataRate: Float
    let segments: [AVAssetTrackSegment]

    /// Нет видеодорожки — [Job.Failure.noVideo].
    static func load(_ url: URL, audio: Bool = false) async throws -> Video {
      let asset = AVURLAsset(url: url)
      guard let track = try await asset.loadTracks(withMediaType: .video).first else { throw Job.Failure.noVideo }
      let duration = try await asset.load(.duration)
      let (size, transform, fps, rate, segments) = try await track.load(
        .naturalSize, .preferredTransform, .nominalFrameRate, .estimatedDataRate, .segments)
      var audioTrack: AVAssetTrack?
      if audio {
        audioTrack = try await asset.loadTracks(withMediaType: .audio).first
      }
      return Video(
        asset: asset, track: track, audio: audioTrack, duration: duration, naturalSize: size,
        preferredTransform: transform, nominalFrameRate: fps, estimatedDataRate: rate, segments: segments)
    }
  }

  /// Размеры (с поворотом), длительность, битрейт и кадр-превью.
  private static func info(_ video: Video, thumb: String?, thumbSide: Int, thumbAtMs: Int) -> [String: Any] {
    let size = displaySize(video.naturalSize, video.preferredTransform)
    var info: [String: Any] = [
      "width": Int(size.width.rounded()),
      "height": Int(size.height.rounded()),
      "durationMs": Int((CMTimeGetSeconds(video.duration) * 1000).rounded()),
      "bitrate": Int(video.estimatedDataRate),
      "fps": Double(video.nominalFrameRate),
    ]
    if let thumb {
      let generator = AVAssetImageGenerator(asset: video.asset)
      generator.appliesPreferredTrackTransform = true
      generator.maximumSize = CGSize(width: thumbSide, height: thumbSide)
      if thumbAtMs > 0 {
        // Обложка из редактора — ровно выбранный кадр, а не ближайший ключевой.
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero
      }
      let at = CMTime(value: CMTimeValue(thumbAtMs), timescale: 1000)
      if let image = try? generator.copyCGImage(at: at, actualTime: nil),
         let data = Self.jpeg(image, quality: 0.75),
         (try? data.write(to: URL(fileURLWithPath: thumb))) != nil {
        info["thumb"] = thumb
      }
    }
    return info
  }

  /// Кадры для ленты редактора: `count` штук по центрам равных отрезков.
  private static func frames(_ video: Video, count: Int, side: Int, prefix: String) -> [String] {
    let duration = CMTimeGetSeconds(video.duration)
    guard count > 0, duration > 0 else { return [] }
    let generator = AVAssetImageGenerator(asset: video.asset)
    generator.appliesPreferredTrackTransform = true
    generator.maximumSize = CGSize(width: side, height: side)
    // Для ленты точность не нужна — допуск ускоряет (берётся ближний кадр).
    let tolerance = CMTime(seconds: duration / Double(count) / 2, preferredTimescale: 600)
    generator.requestedTimeToleranceBefore = tolerance
    generator.requestedTimeToleranceAfter = tolerance
    return (0..<count).map { i in
      let time = CMTime(seconds: duration * (Double(i) + 0.5) / Double(count), preferredTimescale: 600)
      let file = "\(prefix)_\(i).jpg"
      guard let image = try? generator.copyCGImage(at: time, actualTime: nil),
            let data = Self.jpeg(image, quality: 0.7),
            (try? data.write(to: URL(fileURLWithPath: file))) != nil
      else { return "" }
      return file
    }
  }

  private static func jpeg(_ image: CGImage, quality: CGFloat) -> Data? {
    #if os(iOS)
    return UIImage(cgImage: image).jpegData(compressionQuality: quality)
    #else
    return NSBitmapImageRep(cgImage: image).representation(using: .jpeg, properties: [.compressionFactor: quality])
    #endif
  }

  static func displaySize(_ natural: CGSize, _ transform: CGAffineTransform) -> CGSize {
    let rect = CGRect(origin: .zero, size: natural).applying(transform)
    return CGSize(width: abs(rect.width), height: abs(rect.height))
  }

  /// Одно сжатие: чтение исходника и запись H.264 нужного размера/битрейта.
  final class Job {
    enum Failure: Error, Equatable { case noVideo, cancelled, reader, writer, unsupported }

    let source: URL
    let output: URL
    let shortSide: Int
    let bitrate: Int
    let hevc: Bool
    let maxFps: Int
    let startMs: Int
    let endMs: Int
    let mute: Bool
    /// [left, top, width, height] долями показываемого кадра; `nil` — весь.
    let crop: [CGFloat]?
    /// По часовой после кадрирования.
    let rotation: Int
    var onProgress: ((Double) -> Void)?

    private let lock = NSLock()
    private var cancelled = false
    private var reader: AVAssetReader?
    private var writer: AVAssetWriter?

    init(source: URL, output: URL, shortSide: Int, bitrate: Int, hevc: Bool, maxFps: Int, startMs: Int, endMs: Int, mute: Bool, crop: [CGFloat]?, rotation: Int) {
      self.source = source
      self.output = output
      self.shortSide = shortSide
      self.bitrate = bitrate
      self.hevc = hevc
      self.maxFps = maxFps
      self.startMs = startMs
      self.endMs = endMs
      self.mute = mute
      self.crop = crop?.count == 4 ? crop : nil
      self.rotation = ((rotation % 360) + 360) % 360
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

    /// Чётная сторона для кодека, не меньше 2.
    static func even(_ v: CGFloat) -> Int { max(2, Int(v.rounded()) & ~1) }

    /// Композиция для кадрирования [crop] показываемого кадра и поворота на
    /// [rotation] по часовой; короткая сторона результата — не больше
    /// [shortSide] (0 — без уменьшения). Возвращает и размер кадра.
    static func reframe(
      _ video: Video,
      crop: [CGFloat]?,
      rotation: Int,
      shortSide: Int,
      maxFps: Int
    ) -> (AVVideoComposition, (width: Int, height: Int)) {
      // Показываемый кадр: исходный с поворотом из метаданных, от (0, 0).
      let preferred = video.preferredTransform
      let shown = CGRect(origin: .zero, size: video.naturalSize).applying(preferred)
      let c = crop ?? [0, 0, 1, 1]
      let cropRect = CGRect(
        x: c[0] * abs(shown.width),
        y: c[1] * abs(shown.height),
        width: max(1, c[2] * abs(shown.width)),
        height: max(1, c[3] * abs(shown.height))
      )
      let shortest = min(cropRect.width, cropRect.height)
      let scale = shortSide > 0 ? min(1, CGFloat(shortSide) / shortest) : 1
      // Размер кадрированного до поворота (чётный, чтобы и после поворота).
      let cropW = even(cropRect.width * scale)
      let cropH = even(cropRect.height * scale)
      let quarter = rotation % 180 != 0

      // Координаты композиции — от левого верхнего угла, y вниз: положительный
      // угол поворачивает по часовой.
      let rotate = CGAffineTransform(rotationAngle: CGFloat(rotation) * .pi / 180)
      let rotated = CGRect(x: 0, y: 0, width: cropW, height: cropH).applying(rotate)
      let transform = preferred
        .concatenating(CGAffineTransform(translationX: -shown.minX - cropRect.minX, y: -shown.minY - cropRect.minY))
        .concatenating(CGAffineTransform(scaleX: CGFloat(cropW) / cropRect.width, y: CGFloat(cropH) / cropRect.height))
        .concatenating(rotate)
        .concatenating(CGAffineTransform(translationX: -rotated.minX, y: -rotated.minY))

      let layer = AVMutableVideoCompositionLayerInstruction(assetTrack: video.track)
      layer.setTransform(transform, at: .zero)
      let instruction = AVMutableVideoCompositionInstruction()
      instruction.timeRange = CMTimeRange(start: .zero, duration: video.duration)
      instruction.layerInstructions = [layer]

      let composition = AVMutableVideoComposition()
      composition.instructions = [instruction]
      let size = (width: quarter ? cropH : cropW, height: quarter ? cropW : cropH)
      composition.renderSize = CGSize(width: size.width, height: size.height)
      // Композиция выдаёт кадры с этой частотой — сразу не выше maxFps.
      let nominal = video.nominalFrameRate > 0 ? Double(video.nominalFrameRate) : 30
      let fps = maxFps > 0 ? min(nominal, Double(maxFps)) : nominal
      composition.frameDuration = CMTime(value: 1, timescale: CMTimeScale(max(1, fps.rounded())))
      return (composition, size)
    }

    func run(completion: @escaping (Error?) -> Void) {
      Task {
        do {
          let video = try await Video.load(source, audio: !mute)
          try start(video, completion: completion)
        } catch {
          completion(error)
        }
      }
    }

    private func start(_ video: Video, completion: @escaping (Error?) -> Void) throws {
      let asset = video.asset
      let videoTrack = video.track
      let audioTrack = video.audio
      // Обрезка: читаем только [start, end); запись начинается со start —
      // в файле видео идёт с нуля.
      let reframe = crop != nil || rotation != 0
      var start = CMTime(value: CMTimeValue(startMs), timescale: 1000)
      // Изображение в дорожке может начинаться не с нуля (пустой участок в
      // начале — у видео из галереи бывает). AVVideoComposition рисует там
      // чёрные кадры — первый кадр и обложка выходили чёрными; начинаем с
      // первого настоящего кадра.
      if reframe, let first = video.segments.first(where: { !$0.isEmpty })?.timeMapping.target.start {
        start = CMTimeMaximum(start, first)
      }
      let end = endMs > 0 ? min(CMTime(value: CMTimeValue(endMs), timescale: 1000), video.duration) : video.duration
      let range = CMTimeRange(start: start, end: end)
      let duration = max(CMTimeGetSeconds(range.duration), 0.001)
      let startSeconds = CMTimeGetSeconds(start)

      let pixelFormat: [String: Any] = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
      let width: Int
      let height: Int
      let videoOut: AVAssetReaderOutput
      if reframe {
        // Кадрирование и поворот — через AVVideoComposition: кадр
        // «запекается» уже повёрнутым, transform у дорожки не нужен.
        let (composition, size) = Self.reframe(video, crop: crop, rotation: rotation, shortSide: shortSide, maxFps: maxFps)
        width = size.width
        height = size.height
        let output = AVAssetReaderVideoCompositionOutput(videoTracks: [videoTrack], videoSettings: pixelFormat)
        output.videoComposition = composition
        videoOut = output
      } else {
        // Размер в исходной (до поворота) ориентации: короткая сторона →
        // shortSide, не увеличиваем; кодеку нужны чётные стороны.
        let natural = video.naturalSize
        let shortest = min(natural.width, natural.height)
        let scale = shortSide > 0 && shortest > 0 ? min(1, CGFloat(shortSide) / shortest) : 1
        width = Self.even(natural.width * scale)
        height = Self.even(natural.height * scale)
        videoOut = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: pixelFormat)
      }

      try? FileManager.default.removeItem(at: output)
      let reader = try AVAssetReader(asset: asset)
      if start > .zero || endMs > 0 { reader.timeRange = range }
      let writer = try AVAssetWriter(outputURL: output, fileType: .mp4)
      writer.shouldOptimizeForNetworkUse = true
      self.reader = reader
      self.writer = writer

      videoOut.alwaysCopiesSampleData = false
      reader.add(videoOut)
      // HEVC Main (8 бит) — в MP4 пишется как `hvc1`, его играют iOS и
      // Android; H.264 High — запасной вариант.
      let videoSettings: [String: Any] = [
        AVVideoCodecKey: hevc ? AVVideoCodecType.hevc : AVVideoCodecType.h264,
        AVVideoWidthKey: width,
        AVVideoHeightKey: height,
        AVVideoCompressionPropertiesKey: [
          AVVideoAverageBitRateKey: bitrate,
          AVVideoProfileLevelKey: hevc ? kVTProfileLevel_HEVC_Main_AutoLevel as String : AVVideoProfileLevelH264HighAutoLevel,
          AVVideoMaxKeyFrameIntervalDurationKey: 2,
        ],
      ]
      guard writer.canApply(outputSettings: videoSettings, forMediaType: .video) else { throw Failure.unsupported }
      let videoIn = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
      // Без правок кадра поворот не «запекаем» — пишем как в исходнике,
      // плееры его учитывают.
      if !reframe { videoIn.transform = video.preferredTransform }
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
      writer.startSession(atSourceTime: start)

      let group = DispatchGroup()
      var lastReported = -1.0
      // Прореживание до maxFps: кадр пишем, только если от предыдущего
      // записанного прошло не меньше 1/maxFps (с допуском на неровные
      // метки времени — 60 к/с → каждый второй, 30 к/с — все).
      let minFrameInterval = maxFps > 0 ? 1.0 / Double(maxFps) - 0.002 : 0
      var lastFrameTime = -Double.infinity

      func pump(_ input: AVAssetWriterInput, _ output: AVAssetReaderOutput, queue: DispatchQueue, video: Bool) {
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
              if time - lastFrameTime < minFrameInterval { continue }
              lastFrameTime = time
              let progress = min(1, max(0, (time - startSeconds) / duration))
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
