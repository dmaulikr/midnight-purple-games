//
//  WKWebView.swift
//  February 3, 2017
//  Caleb Hess
//

import WebKit

public extension WKWebView {
    public func js(_ script: String, callBack: @escaping (String) -> Void) {
        let clean = script.replace(["'": "\'", "\n": "\\n"])
        
        self.evaluateJavaScript(clean, completionHandler: { result, error in
            if let res = result {
                callBack(String(describing: res))
            } else {
                if let err = error as? NSError {
                    if let exceptionMessage = err.userInfo["WKJavaScriptExceptionMessage"] {
                        Swift.print("JavaScript " + String(describing: exceptionMessage))
                    }
                }
            }
        })
    }
    
    public func js(_ script: String) {
        js(script, callBack: { _ in })
    }
    
    public func html(_ id: String, content: String, appending: Bool) {
        var clean = content.replace(["'": "\\'", "\n": "\\n"])
        
        #if os(OSX)
            clean = clean.replace(["ontouchstart": "onmousedown", "ontouchend": "onmouseup", "ontouchmove": "onmousemove"])
        #endif
        
        if appending {
            js("document.getElementById('" + id + "').innerHTML += '" + clean + "';")
        } else {
            js("document.getElementById('" + id + "').innerHTML = '" + clean + "';")
        }
    }
    
    public func html(_ id: String) {
        html(id, content: "", appending: false)
    }
    
    public func html(_ id: String, content: String) {
        html(id, content: content, appending: false)
    }
    
    public func control(_ id: String, filename: String, values: [String: String] = [:], appending: Bool = false) {
        html(id, content: File.html(filename, values: values), appending: appending)
    }
    
    public func popup(_ message: String) {
        var html = ""
        
        html += File.sharedHTML("popup-message.html", values: ["message": message])
        html += File.sharedHTML("popup-full-button.html", values: ["text": "OK", "function": "popup.close()"])
        
        self.html("popup-holder", content: html)
        self.js("popup.show()")
    }
    
    public func popup(_ message: String, okFunction: String) {
        var html = ""
        var yes = okFunction
        
        if yes == "" {
            yes = "popup.close()"
        }
        
        html += File.sharedHTML("popup-message.html", values: ["message": message])
        html += File.sharedHTML("popup-full-button.html", values: ["text": "OK", "function": yes + ";popup.close()"])
        self.html("popup-holder", content: html)
        self.js("popup.show()")
    }
    
    public func popup(_ message: String, yesFunction: String, noFunction: String) {
        var html = ""
        let yes = (yesFunction == "") ? "popup.close()" : yesFunction + ";popup.close()"
        let no = (noFunction == "") ? "popup.close()" : noFunction + ";popup.close()"
        
        html += File.sharedHTML("popup-message.html", values: ["message": message])
        html += File.sharedHTML("popup-half-button.html", values: ["text": "NO", "function": no + ";popup.close()"])
        html += File.sharedHTML("popup-half-button.html", values: ["text": "YES", "function": yes + ";popup.close()"])
        self.html("popup-holder", content: html)
        self.js("popup.show()")
    }
    
    public func popupInput(_ message: String, placeHolder: String, okFunction: String) {
        var html = ""
        let yes = (okFunction == "") ? "popup.close()" : okFunction + ";popup.close()"
        
        html += File.sharedHTML("popup-message.html", values: ["message": message])
        html += File.sharedHTML("popup-input.html", values: ["type": "text", "placeholder": placeHolder, "value": "", "function": yes + ";popup.close()"])
        html += File.sharedHTML("popup-half-button.html", values: ["text": "CANCEL", "function": "popup.close()"])
        html += File.sharedHTML("popup-half-button.html", values: ["text": "OK", "function": yes + ";popup.close()"])
        self.html("popup-holder", content: html)
        self.js("popup.show()")
    }
}
