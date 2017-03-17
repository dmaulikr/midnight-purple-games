//
//  AppDelegate.swift
//  app-desktop
//
//  Created by caleb on 3/21/16.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    var viewController : ViewController!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        viewController = ViewController(nibName: "ViewController", bundle: nil)
        window.contentView = self.viewController!.view
        window.contentViewController = self.viewController!
        viewController!.view.frame = self.window.contentView!.bounds;
        
        // get frame from saved position
        let defaults = NSUserDefaults()
        
        if (defaults.objectForKey("window_x") != nil) {
            let x = CGFloat(defaults.doubleForKey("window_x"))
            let y = CGFloat(defaults.doubleForKey("window_y"))
            let width = CGFloat(defaults.doubleForKey("window_width"))
            let height = CGFloat(defaults.doubleForKey("window_height"))
            self.window.setFrame(CGRectMake(x, y, width, height), display: true)
        } else {
            self.window.setFrame(CGRectMake(70, 70, 600, 800), display: true)
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
