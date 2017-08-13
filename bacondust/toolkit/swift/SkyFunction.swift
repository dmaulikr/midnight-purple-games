//
//  SkyFunction.swift
//  March 20, 2017
//  Caleb Hess
//
//  toolkit-swift
//

import WebKit

public typealias Func_Void = (Void) -> (Void)
public typealias Func_Web = (WKWebView) -> (Void)
public typealias Func_Int = (Int) -> (Void)
public typealias Func_String = (String) -> (Void)
public typealias Func_NSDict = (NSDictionary) -> (Void)
public typealias Func_Web_Int = (WKWebView, Int) -> (Void)
public typealias Func_Web_String = (WKWebView, String) -> (Void)
public typealias Func_Web_NSDict = (WKWebView, NSDictionary) -> (Void)

public enum SkyFunctionType {
    case Type_Void (Func_Void)
    case Type_Web (Func_Web)
    case Type_Int (Func_Int)
    case Type_String (Func_String)
    case Type_NSDict (Func_NSDict)
    case Type_Web_Int (Func_Web_Int)
    case Type_Web_String (Func_Web_String)
    case Type_Web_NSDict (Func_Web_NSDict)
}

public class SkyFunction {
    var type: SkyFunctionType
    var parameterCount = 0
    
    public init(_ closure: @escaping Func_Void) {
        self.type = SkyFunctionType.Type_Void(closure)
        self.parameterCount = 0
    }
    
    public init(_ closure: @escaping Func_Web) {
        self.type = SkyFunctionType.Type_Web(closure)
        self.parameterCount = 0
    }
    
    public init(_ closure: @escaping Func_Int) {
        self.type = SkyFunctionType.Type_Int(closure)
        self.parameterCount = 1
    }
    
    public init(_ closure: @escaping Func_String) {
        self.type = SkyFunctionType.Type_String(closure)
        self.parameterCount = 1
    }
    
    public init(_ closure: @escaping Func_NSDict) {
        self.type = SkyFunctionType.Type_NSDict(closure)
        self.parameterCount = 1
    }
    
    public init(_ closure: @escaping Func_Web_Int) {
        self.type = SkyFunctionType.Type_Web_Int(closure)
        self.parameterCount = 1
    }
    
    public init(_ closure: @escaping Func_Web_String) {
        self.type = SkyFunctionType.Type_Web_String(closure)
        self.parameterCount = 1
    }
    
    public init(_ closure: @escaping Func_Web_NSDict) {
        self.type = SkyFunctionType.Type_Web_NSDict(closure)
        self.parameterCount = 1
    }
    
    public func script(scope: String, method: String) -> String {
        var param = [String]()
        var paramObject = [String]()
        var script = ""
        
        if parameterCount > 0 {
            for n in 0..<parameterCount {
                let pString = "p" + String(n + 1)
                param.append(pString)
                paramObject.append("'" + pString + "':" + pString)
            }
            
            let paramString = param.joined(separator: ",")
            let paramObjectString = "{" + paramObject.joined(separator: ",") + "}"
            script = "sky." + scope + "." + method + "=function(" + paramString + "){sky.native('" + scope + "','" + method + "'," + paramObjectString + ");};"
        } else {
            script = "sky." + scope + "." + method + "=function(){sky.native('" + scope + "','" + method + "','');};"
        }
        
        return script
    }
    
    public func run(_ web: WKWebView, params: NSDictionary) {
        switch type {
        case let .Type_Void(type):
            type()
        case let .Type_Web(type):
            type(web)
        case let .Type_Int(type):
            type(params.int("p1"))
        case let .Type_String(type):
            type(params.string("p1"))
        case let .Type_NSDict(type):
            type(params.dict("p1"))
        case let .Type_Web_Int(type):
            type(web, params.int("p1"))
        case let .Type_Web_String(type):
            type(web, params.string("p1"))
        case let .Type_Web_NSDict(type):
            type(web, params.dict("p1"))
        }
    }
}
