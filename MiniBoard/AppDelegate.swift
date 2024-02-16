import Cocoa
import SwiftData
import SwiftUI

class WindowInfo: ObservableObject {
  @Published var frame: CGRect = .zero
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var keyboardShortcutHandler: KeyboardShortcutHandler?
    var windowController: NSWindowController?
    var eventMonitor: Any?
    
    var timer: Timer!
    let pasteboard: NSPasteboard = .general
    var lastChangeCount: Int = 0
    
    let windowInfo = WindowInfo()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let window = NSApplication.shared.windows.first {
                window.close()
            }
        keyboardShortcutHandler = KeyboardShortcutHandler()
        NotificationCenter.default.addObserver(self, selector: #selector(showWindow), name: .showWindowNotification, object: nil)
        setupEventMonitor()
        
        //Timer that will watch changes in the clipboard and will post them to the notification center
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (t) in
            if self.lastChangeCount != self.pasteboard.changeCount {
                self.lastChangeCount = self.pasteboard.changeCount
                NotificationCenter.default.post(name: .NSPasteboardDidChange, object: self.pasteboard)
                
            }
        }
    }

    @objc func showWindow() {
        windowController?.window?.animator().alphaValue = 0
        windowController?.close()

        let cursorPosition = NSEvent.mouseLocation
        let windowWidth: CGFloat = 200
        let windowHeight: CGFloat = 300
        let windowRect = NSRect(x: cursorPosition.x, y: cursorPosition.y - windowHeight, width: windowWidth, height: windowHeight)

        let contentView = ListView()
            .modelContainer(for: [ClipboardItem.self])
        
        let hostingController = NSHostingController(rootView: contentView)

        let window = NSWindow(contentRect: windowRect, styleMask: [.borderless], backing: .buffered, defer: false)
        window.isMovableByWindowBackground = true
        window.hasShadow = true
        window.backgroundColor = NSColor.clear
        window.isOpaque = false
        window.alphaValue = 0  // Start transparent
        window.level = .floating //Bring it to the foreground

        // Set the hostingController's view as the window's contentView
        window.contentView = hostingController.view

        windowController = NSWindowController(window: window)
        windowController?.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)

        // Animate window fade-in
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2  // Adjust duration as needed
            window.animator().alphaValue = 1
        }
        
        self.windowInfo.frame = window.frame
    }


    private func setupEventMonitor() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            guard let strongSelf = self, let window = strongSelf.windowController?.window else { return }
            if !window.frame.contains(event.locationInWindow) {
                // Animate window fade-out
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.2  // Adjust duration as needed
                    window.animator().alphaValue = 0
                }, completionHandler: {
                    strongSelf.windowController?.close()
                })
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        timer.invalidate()
    }
}


extension Notification.Name {
    public static let NSPasteboardDidChange: NSNotification.Name = .init(rawValue: "pasteboardDidChangeNotification")
    
    static let showWindowNotification = Notification.Name("showWindowNotification")
}
