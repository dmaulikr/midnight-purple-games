//
//  WKWebView 1.0
//  Created by Caleb Hess on 8/16/16.
//

import WebKit

public extension WKWebView {    
    public func appHTML() -> String {
        let base64FontCSS = "@font-face{font-family:'@family';src:url(data:application/x-font-woff;charset=utf-8;base64,@base64);}"
        let fontFileNames = File.string("font_files.txt")
        let jsFileNames = File.string("js_files.txt")
        let imageFileNames = File.string("image_files.txt")
        let cssFileNames = File.string("css_files.txt")
        var htmlCode = File.string("index.html")
        var cssCode = ""
        var jsCode = ""
    
        #if os(iOS)
            jsCode += File.string("touch.js")
        #else
            htmlCode = osxHTML(htmlCode)
            jsCode += File.string("mouse.js")
        #endif
        
        // make a CSS class for each font in base64
        if fontFileNames.count > 0 {
            let fontArr = fontFileNames.components(separatedBy: "\n")
            
            for fileNameString in fontArr {
                let pieces = fileNameString.components(separatedBy: ".")
                
                if let fontUrl = Bundle.main.url(forResource: pieces[0], withExtension: pieces[1]) {
                    var fontData: Data?
                    do {
                        fontData = try Data(contentsOf: fontUrl, options: [])
                    } catch _ {
                        fontData = nil
                    }
                    let base64String = fontData!.base64EncodedString(options: [])
                    cssCode += base64FontCSS.replace(["@family": pieces[0], "@base64": base64String])
                } else {
                    log("ERROR: Could not find file " + fileNameString)
                }
            }
        }
        
        // all CSS files except themes
        if cssFileNames.count > 0 {
            let cssArr = cssFileNames.components(separatedBy: "\n")
        
            for fileName in cssArr {
                if let filePath = Bundle.main.path(forResource: fileName, ofType: "css") {
                    do {
                        cssCode += try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
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
            let jsArr = jsFileNames.components(separatedBy: "\n")
            
            for fileName in jsArr {
                if let filePath = Bundle.main.path(forResource: fileName, ofType: "js") {
                    do {
                        jsCode += try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
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
            let imageArr = imageFileNames.components(separatedBy: "\n")
            
            for fileNameString in imageArr {
                let pieces = fileNameString.components(separatedBy: ".")
                
                if let imageUrl = Bundle.main.url(forResource: pieces[0], withExtension: pieces[1]) {
                    var imageData: Data?
                    do {
                        imageData = try Data(contentsOf: imageUrl, options: [])
                    } catch _ {
                        imageData = nil
                    }
                    let base64String = imageData!.base64EncodedString(options: [])
                    cssCode += ".image-" + pieces[0] + "{ background-image: url(\"data:image/png;base64," + base64String + "\"); }"
                } else {
                    log("ERROR: Could not find file - " + fileNameString)
                }
            }
        }
        
        // put it all together
        return "<html><head><meta name=\"viewport\" content=\"width=device-width, height=device-height; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"><style>" + cssCode + "</style></head><body>" + htmlCode + "<script>" + jsCode + "</script></body></html>"
    }
    
    public func js(_ code: String) {
        self.evaluateJavaScript(code.replace(["'": "\'", "\n": "\\n"]), completionHandler: nil)
    }
    
    public func osxHTML(_ content: String) -> String {
        return content.replace(["ontouchstart": "onmousedown", "ontouchend": "onmouseup", "ontouchmove": "onmousemove"])
    }
    
    public func innerHTML(_ id: String) {
        self.evaluateJavaScript("document.getElementById('" + id + "').innerHTML = '';", completionHandler: nil)
    }
    
    public func innerHTML(_ id: String, content: String) {
        var clean = content.replace(["'": "\\'", "\n": "\\n"])
        
        #if os(OSX)
            clean = osxHTML(clean)
        #endif
        
        let js = "document.getElementById('" + id + "').innerHTML = '" + clean + "';"
        self.evaluateJavaScript(js, completionHandler: nil)
    }
    
    public func innerHTML(_ id: String, content: String, appending: Bool) {
        var clean = content.replace(["'": "\\'", "\n": "\\n"])
        
        #if os(OSX)
            clean = osxHTML(clean)
        #endif
        
        let js = "document.getElementById('" + id + "').innerHTML " + (appending ? "+" : "") + "= '" + clean + "';"
        self.evaluateJavaScript(js, completionHandler: nil)
    }
    
    public func control(_ id: String) {
        innerHTML(id, content: File.string(id + ".html", values: [:]), appending: false)
    }
    
    public func control(_ id: String, values: [String:String]) {
        innerHTML(id, content: File.string(id + ".html", values: values), appending: false)
    }
    
    public func control(_ id: String, filename: String) {
        innerHTML(id, content: File.string(filename + ".html", values: [:]), appending: false)
    }
    
    public func control(_ id: String, filename: String, values: [String:String]) {
        innerHTML(id, content: File.string(filename + ".html", values: values), appending: false)
    }
    
    public func control(_ id: String, filename: String, values: [String:String], appending: Bool) {
        innerHTML(id, content: File.string(filename + ".html", values: values), appending: appending)
    }
    
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0);
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true);
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snapshotImage;
    }
    
    func log(_ msg: String) {
        #if os(iOS)
            print(msg)
        #else
            NSLog(msg)
        #endif
    }
}
