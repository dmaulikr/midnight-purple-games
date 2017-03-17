//
//  Utils.swift
//  Optic Blue
//
//  Created by caleb on 2/3/16.
//  Copyright © 2016 Midnight Purple Games. All rights reserved.
//

import WebKit
import Foundation

public extension WKWebView {
    public func appHTML() -> String {
        let base64FontCSS = "@font-face{font-family:'@family';src:url(data:application/x-font-woff;charset=utf-8;base64,@base64);}"
        let fontFileNames = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("font_files", ofType: "txt")!, encoding: NSUTF8StringEncoding)
        let jsFileNames = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("js_files", ofType: "txt")!, encoding: NSUTF8StringEncoding)
        let imageFileNames = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("image_files", ofType: "txt")!, encoding: NSUTF8StringEncoding)
        let cssFileNames = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("css_files", ofType: "txt")!, encoding: NSUTF8StringEncoding)
        let htmlCode = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("index", ofType: "html")!, encoding: NSUTF8StringEncoding)
        var cssCode = ""
        var jsCode = ""
        
        // make a CSS class for each font in base64
        if fontFileNames.count > 0 {
            let fontArr = fontFileNames.componentsSeparatedByString(",")
            
            for fileNameString in fontArr {
                let fontUrl = NSBundle.mainBundle().URLForResource(fileNameString, withExtension: "ttf")
                var fontData: NSData?
                do {
                    fontData = try NSData(contentsOfURL: fontUrl!, options: [])
                } catch _ {
                    fontData = nil
                }
                let base64String = fontData!.base64EncodedStringWithOptions([])
                cssCode += base64FontCSS.replace(["@family": fileNameString, "@base64": base64String])
            }
        }
        
        // all CSS files except themes
        if cssFileNames.count > 0 {
            let cssArr = cssFileNames.componentsSeparatedByString(",")
            
            for fileName in cssArr {
                if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "css") {
                    do {
                        cssCode += try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
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
            let jsArr = jsFileNames.componentsSeparatedByString(",")
            
            for fileName in jsArr {
                if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "js") {
                    do {
                        jsCode += try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
                    } catch {
                        print("ERROR: Could not form String from file - " + fileName + ".js")
                    }
                } else {
                    print("ERROR: Could not find file - " + fileName + ".js")
                }
            }
        }
        
        // make a CSS class for each font in base64
        if imageFileNames.count > 0 {
            let imageArr = imageFileNames.componentsSeparatedByString(",")
            
            for fileNameString in imageArr {
                let pieces = fileNameString.componentsSeparatedByString(".")
                let fontUrl = NSBundle.mainBundle().URLForResource(pieces[0], withExtension: pieces[1])
                var fontData: NSData?
                do {
                    fontData = try NSData(contentsOfURL: fontUrl!, options: [])
                } catch _ {
                    fontData = nil
                }
                let base64String = fontData!.base64EncodedStringWithOptions([])
                cssCode += ".image-" + pieces[0] + "{ background-image: url(\"data:image/png;base64," + base64String + "\"); }"
            }
        }
        
        // put it all together
        return "<html><head><meta name=\"viewport\" content=\"width=device-width, height=device-height; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"><style>" + cssCode + "</style></head><body>" + htmlCode + "<script>" + jsCode + "</script></body></html>"
    }
    
    public func js(code: String) {
        self.evaluateJavaScript(code.replace(["'": "\'", "\n": "\\n"]), completionHandler: nil)
    }
    
    public func innerHTML(id: String) {
        self.evaluateJavaScript("document.getElementById('" + id + "').innerHTML = '';", completionHandler: nil)
    }
    
    public func innerHTML(id: String, content: String) {
        let clean = content.replace(["'": "\\'", "\n": "\\n"])
        let js = "document.getElementById('" + id + "').innerHTML = '" + clean + "';"
        self.evaluateJavaScript(js, completionHandler: nil)
    }
    
    public func innerHTML(id: String, content: String, appending: Bool) {
        let clean = content.replace(["'": "\\'", "\n": "\\n"])
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
}

// ---------------------------------------------------------------------------------------------------------------------------------

public extension String {
    public var count: Int { return self.characters.count }
    
    public subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
    
    public func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    public func replace(target: String, with: String) -> String {
        return self.stringByReplacingOccurrencesOfString(target, withString: with)
    }
    
    public func replace(target: String) -> String {
        return replace(target, with: "")
    }
    
    public func replace(values: [String:String]) -> String {
        var result = self
        
        for (target, with) in values {
            result = result.replace(target, with: with)
        }
        
        return result
    }
    
    public func replace(values: [String]) -> String {
        var result = self
        
        for (target) in values {
            result = result.replace(target, with: "")
        }
        
        return result
    }
    
    public func indexOf(target: String) -> Int {
        if let range = self.rangeOfString(target) {
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    public func contains(target: String) -> Bool {
        return self.indexOf(target) != -1
    }
    
    public func dataFromHexadecimalString() -> NSData? {
        let trimmedString = self.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<> ")).stringByReplacingOccurrencesOfString(" ", withString: "")
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]*$", options: NSRegularExpressionOptions.CaseInsensitive)
        let found = regex.firstMatchInString(trimmedString, options: NSMatchingOptions.WithTransparentBounds, range: NSMakeRange(0, trimmedString.count))
        if found == nil || found?.range.location == NSNotFound || trimmedString.count % 2 != 0 {
            return nil
        }
        
        let data = NSMutableData(capacity: trimmedString.count / 2)
        
        for var index = trimmedString.startIndex; index < trimmedString.endIndex; index = index.successor().successor() {
            let byteString = trimmedString.substringWithRange(Range<String.Index>(start: index, end: index.successor().successor()))
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data?.appendBytes([num] as [UInt8], length: 1)
        }
        
        return data
    }
    
    public func stringFromHexadecimalStringUsingEncoding(encoding: NSStringEncoding) -> String? {
        if let data = dataFromHexadecimalString() {
            return NSString(data: data, encoding: encoding) as? String
        }
        
        return nil
    }
}

// ---------------------------------------------------------------------------------------------------------------------------------

public extension NSBundle {
    public var versionNumber: String {
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        
        return ""
    }
    
    public var buildNumber: String {
        if let build = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        
        return ""
    }
    
    public var versionAndBuild: String{
        return self.versionNumber + " - (" + self.buildNumber + ")"
    }
    
    public func fileString(filename: String, values: [String:String]) -> String {
        var controlHTML = ""
        var fileNamePieces = filename.componentsSeparatedByString(".")
        
        if fileNamePieces.count > 1 {
            do {
                if let filePath = NSBundle.mainBundle().pathForResource(fileNamePieces[0], ofType: fileNamePieces[1]) {
                    controlHTML = try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
                    
                    for (key, value) in values {
                        controlHTML = controlHTML.stringByReplacingOccurrencesOfString("@" + key, withString: value)
                    }
                } else {
                    print("VGR FRAMEWORK ERROR: Could not resolve file path for '" + filename + "'.")
                }
            } catch {
                print("VGR FRAMEWORK ERROR: Could not get file contents for '" + filename + "'.")
            }
        } else {
            print("VGR FRAMEWORK ERROR: There is no file extension for '" + filename + "'.")
        }
        
        return controlHTML
    }
}

// ---------------------------------------------------------------------------------------------------------------------------------

public class StopWatch {
    var timeStart = CFAbsoluteTimeGetCurrent()
    var timeElapsed = CFAbsoluteTimeGetCurrent()
    var sum = 0.0
    
    public func start() {
        sum = 0.0
        timeStart = CFAbsoluteTimeGetCurrent()
    }
    
    public func stop() -> Double {
        timeElapsed = CFAbsoluteTimeGetCurrent() - timeStart
        sum += timeElapsed
        timeStart = CFAbsoluteTimeGetCurrent()
        return timeElapsed
    }
    
    public func statistics() {
        let ms = Int(round(timeElapsed * 1000.0))
        print("time elapsed: \(ms) ms")
    }
}