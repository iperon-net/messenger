import Flutter
import Photos
import QuickLook
import UIKit
import UniformTypeIdentifiers

/// Файлы и медиа чата для системы (см. lib/chats/media_files.dart). Канал
/// `net.iperon.messenger/files`:
/// - `open` {path} → Quick Look (просмотр с кнопкой «Поделиться»); `false` —
///   такой тип Quick Look не показывает;
/// - `copy` {paths} → в буфер обмена: каждый файл — отдельный элемент с типом
///   по расширению (`public.jpeg`, `public.mpeg-4` …), так фото и видео
///   вставляются в другие приложения;
/// - `saveToGallery` {path, video} → в «Фото» (доступ только на добавление);
///   ошибка `denied` — доступа нет;
/// - `saveFile` {path} → «Сохранить в Файлы» (экспорт копии); `false` —
///   отменили.
final class MediaFiles: NSObject {
  static let shared = MediaFiles()

  private var channel: FlutterMethodChannel?
  private var previewURL: URL?
  private var exportResult: FlutterResult?

  func attach(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "net.iperon.messenger/files", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    self.channel = channel
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "open":
      guard let path = args["path"] as? String else {
        return result(FlutterError(code: "args", message: "path", details: nil))
      }
      open(URL(fileURLWithPath: path), result: result)
    case "copy":
      guard let paths = args["paths"] as? [String], !paths.isEmpty else {
        return result(FlutterError(code: "args", message: "paths", details: nil))
      }
      copy(paths.map { URL(fileURLWithPath: $0) }, result: result)
    case "saveToGallery":
      guard let path = args["path"] as? String else {
        return result(FlutterError(code: "args", message: "path", details: nil))
      }
      saveToGallery(URL(fileURLWithPath: path), video: args["video"] as? Bool ?? false, result: result)
    case "saveFile":
      guard let path = args["path"] as? String else {
        return result(FlutterError(code: "args", message: "path", details: nil))
      }
      export(URL(fileURLWithPath: path), result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Открыть

  private func open(_ url: URL, result: @escaping FlutterResult) {
    guard QLPreviewController.canPreview(url as NSURL), let top = Self.topViewController() else {
      return result(false)
    }
    previewURL = url
    let preview = QLPreviewController()
    preview.dataSource = self
    top.present(preview, animated: true)
    result(true)
  }

  // MARK: - Буфер обмена

  private func copy(_ urls: [URL], result: @escaping FlutterResult) {
    DispatchQueue.global(qos: .userInitiated).async {
      var items: [[String: Any]] = []
      for url in urls {
        guard let data = try? Data(contentsOf: url, options: .mappedIfSafe) else { continue }
        let type = UTType(filenameExtension: url.pathExtension) ?? .data
        items.append([type.identifier: data])
      }
      DispatchQueue.main.async {
        guard !items.isEmpty else {
          return result(FlutterError(code: "failed", message: "no readable files", details: nil))
        }
        UIPasteboard.general.setItems(items, options: [:])
        result(nil)
      }
    }
  }

  // MARK: - Галерея

  private func saveToGallery(_ url: URL, video: Bool, result: @escaping FlutterResult) {
    PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
      guard status == .authorized || status == .limited else {
        return DispatchQueue.main.async { result(FlutterError(code: "denied", message: nil, details: nil)) }
      }
      PHPhotoLibrary.shared().performChanges({
        let request = PHAssetCreationRequest.forAsset()
        request.addResource(with: video ? .video : .photo, fileURL: url, options: nil)
      }) { ok, error in
        DispatchQueue.main.async {
          ok ? result(nil) : result(FlutterError(code: "failed", message: error?.localizedDescription, details: nil))
        }
      }
    }
  }

  // MARK: - Сохранить в Файлы

  private func export(_ url: URL, result: @escaping FlutterResult) {
    guard let top = Self.topViewController() else { return result(false) }
    exportResult?(false)
    exportResult = result
    let picker = UIDocumentPickerViewController(forExporting: [url], asCopy: true)
    picker.delegate = self
    top.present(picker, animated: true)
  }

  private func finishExport(_ saved: Bool) {
    exportResult?(saved)
    exportResult = nil
  }

  /// Верхний показанный контроллер окна приложения — от него показываем
  /// системные экраны поверх Flutter.
  private static func topViewController() -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let windows = scenes.flatMap { $0.windows }
    var top = (windows.first { $0.isKeyWindow } ?? windows.first)?.rootViewController
    while let presented = top?.presentedViewController {
      top = presented
    }
    return top
  }
}

extension MediaFiles: QLPreviewControllerDataSource {
  func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    previewURL == nil ? 0 : 1
  }

  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    (previewURL ?? URL(fileURLWithPath: "")) as NSURL
  }
}

extension MediaFiles: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    finishExport(true)
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    finishExport(false)
  }
}
