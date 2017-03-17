//
//  WKWebView 1.0
//  Created by Caleb Hess on 2/22/16.
//

import WebKit

public extension WKWebView {    
    public func appHTML() -> String {
        let base64FontCSS = "@font-face{font-family:'@family';src:url(data:application/x-font-woff;charset=utf-8;base64,@base64);}"
        let fontFileNames = NSBundle().fileString("font_files.txt")
        let jsFileNames = NSBundle().fileString("js_files.txt")
        let imageFileNames = NSBundle().fileString("image_files.txt")
        let cssFileNames = NSBundle().fileString("css_files.txt")
        var htmlCode = NSBundle().fileString("index.html")
        var cssCode = ""
        var jsCode = ""
        
        #if os(iOS)
            jsCode += NSBundle().fileString("touch.js")
        #else
            htmlCode = osxHTML(htmlCode)
            jsCode += NSBundle().fileString("mouse.js")
        #endif
        
        // make a CSS class for each font in base64
        if fontFileNames.count > 0 {
            let fontArr = fontFileNames.componentsSeparatedByString("\n")
            
            for fileNameString in fontArr {
                let pieces = fileNameString.componentsSeparatedByString(".")
                
                if let fontUrl = NSBundle.mainBundle().URLForResource(pieces[0], withExtension: pieces[1]) {
                    var fontData: NSData?
                    do {
                        fontData = try NSData(contentsOfURL: fontUrl, options: [])
                    } catch _ {
                        fontData = nil
                    }
                    let base64String = fontData!.base64EncodedStringWithOptions([])
                    cssCode += base64FontCSS.replace(["@family": pieces[0], "@base64": base64String])
                } else {
                    log("ERROR: Could not find file " + fileNameString)
                }
            }
        }
        
        // all CSS files except themes
        if cssFileNames.count > 0 {
            let cssArr = cssFileNames.componentsSeparatedByString("\n")
        
            for fileName in cssArr {
                if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "css") {
                    do {
                        cssCode += try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
                    } catch {
                        log("ERROR: Could not form String from file - " + fileName + ".css")
                    }
                } else {
                    log("ERROR: Could not find file - " + fileName + ".css")
                }
            }
        }
        
        // all JavaScript files
        if jsFileNames.count > 0 {
            let jsArr = jsFileNames.componentsSeparatedByString("\n")
            
            for fileName in jsArr {
                if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "js") {
                    do {
                        jsCode += try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
                    } catch {
                        log("ERROR: Could not form String from file - " + fileName + ".js")
                    }
                } else {
                    log("ERROR: Could not find file - " + fileName + ".js")
                }
            }
        }
        
        // make a CSS class for each image in base64
        if imageFileNames.count > 0 {
            let imageArr = imageFileNames.componentsSeparatedByString("\n")
            
            for fileNameString in imageArr {
                let pieces = fileNameString.componentsSeparatedByString(".")
                
                if let imageUrl = NSBundle.mainBundle().URLForResource(pieces[0], withExtension: pieces[1]) {
                    var imageData: NSData?
                    do {
                        imageData = try NSData(contentsOfURL: imageUrl, options: [])
                    } catch _ {
                        imageData = nil
                    }
                    let base64String = imageData!.base64EncodedStringWithOptions([])
                    cssCode += ".image-" + pieces[0] + "{ background-image: url(\"data:image/png;base64," + base64String + "\"); }"
                } else {
                    log("ERROR: Could not find file - " + fileNameString)
                }
            }
        }
        
        // put it all together
        return "<html><head><meta name=\"viewport\" content=\"width=device-width, height=device-height; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"><style>" + cssCode + "</style></head><body>" + htmlCode + "<script>" + jsCode + "</script></body></html>"
    }
    
    public func js(code: String) {
        self.evaluateJavaScript(code.replace(["'": "\'", "\n": "\\n"]), completionHandler: nil)
    }
    
    public func osxHTML(content: String) -> String {
        return content.replace(["ontouchstart": "onmousedown", "ontouchend": "onmouseup", "ontouchmove": "onmousemove"])
    }
    
    public func innerHTML(id: String) {
        self.evaluateJavaScript("document.getElementById('" + id + "').innerHTML = '';", completionHandler: nil)
    }
    
    public func innerHTML(id: String, content: String) {
        var clean = content.replace(["'": "\\'", "\n": "\\n"])
        
        #if os(OSX)
            clean = osxHTML(clean)
        #endif
        
        let js = "document.getElementById('" + id + "').innerHTML = '" + clean + "';"
        self.evaluateJavaScript(js, completionHandler: nil)
    }
    
    public func innerHTML(id: String, content: String, appending: Bool) {
        var clean = content.replace(["'": "\\'", "\n": "\\n"])
        
        #if os(OSX)
            clean = osxHTML(clean)
        #endif
        
        let js = "document.getElementById('" + id + "').innerHTML " + (appending ? "+" : "") + "= '" + clean + "';"
        self.evaluateJavaScript(js, completionHandler: nil)
    }
    
    public func control(id: String) {
        innerHTML(id, content: NSBundle().fileString(id + ".html", values: [:]), appending: false)
    }
    
    public func control(id: String, values: [String:String]) {
        innerHTML(id, content: NSBundle().fileString(id + ".html", values: values), appending: false)
    }
    
    public func control(id: String, filename: String) {
        innerHTML(id, content: NSBundle().fileString(filename + ".html", values: [:]), appending: false)
    }
    
    public func control(id: String, filename: String, values: [String:String]) {
        innerHTML(id, content: NSBundle().fileString(filename + ".html", values: values), appending: false)
    }
    
    public func control(id: String, filename: String, values: [String:String], appending: Bool) {
        innerHTML(id, content: NSBundle().fileString(filename + ".html", values: values), appending: appending)
    }
    
    func log(msg: String) {
        #if os(iOS)
            print(msg)
        #else
            NSLog(msg)
        #endif
    }
}
