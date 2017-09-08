//
//  KeyboardShortcuts.swift
//  June 28, 2017
//  Caleb Hess
//

import WebKit

extension WKWebView {
    override open func performKeyEquivalent(with: NSEvent) -> Bool {
        if let chars = with.characters {
            if with.modifierFlags.contains(.command) {
                switch chars {
                case "x":
                    if NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: self) { return true }
                case "c":
                    if NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: self) { return true }
                case "v":
                    if NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: self) { return true }
                case "a":
                    if NSApp.sendAction(#selector(NSResponder.selectAll(_:)), to: nil, from: self) { return true }
                case "z":
                    self.undoManager?.undo()
                    return true
                default:
                    break
                }
            }
        }
        
        return super.performKeyEquivalent(with: with)
    }
}
