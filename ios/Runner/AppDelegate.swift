import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    excludeAppDataFromBackup()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  /// Исключает каталоги с данными приложения из резервных копий iCloud/iTunes
  /// через NSURLIsExcludedFromBackupKey. Library/Caches и tmp система и так не
  /// бэкапит, поэтому помечаем только Application Support (зашифрованная БД) и
  /// Documents. Исключение каталога распространяется на всё его содержимое,
  /// включая файлы, созданные позже.
  private func excludeAppDataFromBackup() {
    let fileManager = FileManager.default
    let directories: [FileManager.SearchPathDirectory] = [
      .applicationSupportDirectory,
      .documentDirectory,
    ]
    for directory in directories {
      guard var url = fileManager.urls(for: directory, in: .userDomainMask).first else {
        continue
      }
      // Каталог должен существовать, иначе setResourceValues завершится ошибкой.
      if !fileManager.fileExists(atPath: url.path) {
        try? fileManager.createDirectory(at: url, withIntermediateDirectories: true)
      }
      do {
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try url.setResourceValues(values)
      } catch {
        NSLog("Failed to exclude \(url.path) from backup: \(error)")
      }
    }
  }
}
