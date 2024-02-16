import Cocoa
import Carbon

class KeyboardShortcutHandler {
    private var eventTap: CFMachPort?

    init() {
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                     place: .headInsertEventTap,
                                     options: .defaultTap,
                                     eventsOfInterest: CGEventMask(eventMask),
                                     callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                                        guard type == .keyDown else { return Unmanaged.passUnretained(event) }

                                        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
                                        let semicolonKeyCode: CGKeyCode = 41 // Keycode for semicolon
                                        if keyCode == semicolonKeyCode && event.flags.contains(.maskCommand) {
                                            NotificationCenter.default.post(name: .showWindowNotification, object: nil)
                                            return nil
                                        }
                                        return Unmanaged.passUnretained(event)
                                     },
                                     userInfo: nil)
        if let eventTap = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
    }
}
