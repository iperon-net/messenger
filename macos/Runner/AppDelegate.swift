import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  // Как Telegram Desktop и другие мессенджеры на Mac: закрытое окно не
  // завершает приложение — оно остаётся в Dock, стрим живёт и сообщения
  // приходят; выход — ⌘Q. Окно снова открывает клик по значку в Dock.
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      mainFlutterWindow?.makeKeyAndOrderFront(nil)
    }
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
