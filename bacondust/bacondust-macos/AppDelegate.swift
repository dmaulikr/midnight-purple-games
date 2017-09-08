//
//  AppDelegate.swift
//  March 4, 2017
//  Caleb Hess
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    var viewController : ViewController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        viewController = ViewController(nibName: "ViewController", bundle: nil)
        window.contentView = self.viewController!.view
        window.contentViewController = self.viewController!
        setWindowFrame()
        viewController!.view.frame = self.window.contentView!.bounds
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func setWindowFrame() {
        if let screen = NSScreen.main() {
            let x = screen.visibleFrame.origin.x + 140
            let y = screen.visibleFrame.origin.y + 20
            let width = screen.visibleFrame.size.width - 280
            let height = screen.visibleFrame.size.height - 40
            let frame = NSRect(x: x, y: y, width: width, height: height)
            window.setFrame(frame, display: true)
        }
        
        window.setFrameAutosaveName("concept")
    }
}
