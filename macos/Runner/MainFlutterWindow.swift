import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // По умолчанию шире SplitLayout.minWidth (700) — две панели, как Telegram
    // Desktop. Дальше размер и положение запоминает сам AppKit (autosave name);
    // системное восстановление окна выключено, чтобы не спорило с ним.
    self.isRestorable = false
    self.contentMinSize = NSSize(width: 380, height: 500)
    self.setContentSize(NSSize(width: 1100, height: 760))
    self.center()
    self.setFrameAutosaveName("IperonMainWindow")

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
