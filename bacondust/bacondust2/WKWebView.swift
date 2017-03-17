//
//  WKWebView 1.0
//  Created by Caleb Hess on 2/22/16.
//

import WebKit

public extension WKWebView {
    public func appHTML() -> String {
        let base64FontCSS = "@font-face{font-family:'@family';src:url(data:application/x-font-woff;charset=utf-8;base64,@base64);}"
        let fontFileNames = try! String(contentsOfFile: Bundle.main.path(forResource: "font_files", ofType: "txt")!, encoding: String.Encoding.utf8)
        let jsFileNames = try! String(contentsOfFile: Bundle.main.path(forResource: "js_files", ofType: "txt")!, encoding: String.Encoding.utf8)
        let imageFileNames = try! String(contentsOfFile: Bundle.main.path(forResource: "image_files", ofType: "txt")!, encoding: String.Encoding.utf8)
        let cssFileNames = try! String(contentsOfFile: Bundle.main.path(forResource: "css_files", ofType: "txt")!, encoding: String.Encoding.utf8)
        let htmlCode = try! String(contentsOfFile: Bundle.main.path(forResource: "index", ofType: "html")!, encoding: String.Encoding.utf8)
        var cssCode = ""
        var jsCode = ""
        
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
                    print("ERROR: Could not find file " + fileNameString)
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
                        print("ERROR: Could not form String from file - " + fileName + ".css")
                    }
                } else {
                    print("ERROR: Could not find file - " + fileName + ".css")
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
                        print("ERROR: Could not form String from file - " + fileName + ".js")
                    }
                } else {
                    print("ERROR: Could not find file - " + fileName + ".js")
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
                    print("ERROR: Could not find file - " + fileNameString)
                }
            }
        }
        
        // put it all together
        return "<html><head><meta name=\"viewport\" content=\"width=device-width, height=device-height; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"><style>" + cssCode + "</style></head><body>" + htmlCode + "<script>" + jsCode + "</script></body></html>"
    }
    
    public func js(_ code: String) {
        self.evaluateJavaScript(code.replace(["'": "\'", "\n": "\\n"]), completionHandler: nil)
    }
    
    public func innerHTML(_ id: String) {
        self.evaluateJavaScript("document.getElementById('" + id + "').innerHTML = '';", completionHandler: nil)
    }
    
    public func innerHTML(_ id: String, content: String) {
        let clean = content.replace(["'": "\\'", "\n": "\\n"])
        let js = "document.getElementById('" + id + "').innerHTML = '" + clean + "';"
        self.evaluateJavaScript(js, completionHandler: nil)
    }
    
    public func innerHTML(_ id: String, content: String, appending: Bool) {
        let clean = content.replace(["'": "\\'", "\n": "\\n"])
        let js = "document.getElementById('" + id + "').innerHTML " + (appending ? "+" : "") + "= '" + clean + "';"
        self.evaluateJavaScript(js, completionHandler: nil)
    }
    
    public func control(_ id: String) {
        innerHTML(id, content: Bundle().fileString(id + ".html", values: [:]), appending: false)
    }
    
    public func control(_ id: String, values: [String:String]) {
        innerHTML(id, content: Bundle().fileString(id + ".html", values: values), appending: false)
    }
    
    public func control(_ id: String, filename: String) {
        innerHTML(id, content: Bundle().fileString(filename + ".html", values: [:]), appending: false)
    }
    
    public func control(_ id: String, filename: String, values: [String:String]) {
        innerHTML(id, content: Bundle().fileString(filename + ".html", values: values), appending: false)
    }
    
    public func control(_ id: String, filename: String, values: [String:String], appending: Bool) {
        innerHTML(id, content: Bundle().fileString(filename + ".html", values: values), appending: appending)
    }
}
