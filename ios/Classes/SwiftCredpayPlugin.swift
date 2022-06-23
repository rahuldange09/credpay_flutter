import Flutter
import UIKit



public class SwiftCredpayPlugin: NSObject, FlutterPlugin {
    
    private static var methodChannel: FlutterMethodChannel?
    
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        SwiftCredpayPlugin.methodChannel?.setMethodCallHandler(nil)
    }
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let instance = SwiftCredpayPlugin()
        let channel = FlutterMethodChannel(name: "credpay", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        methodChannel = channel
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
        case "launchCredPay":
            guard let url = (call.arguments as! NSDictionary).value(forKey: "url") as? String else {
                result("fail")
                return
            }
            launchCredPay(uri: url, result: result)
        case "isAppInstalled":
            guard let packageName = (call.arguments as! NSDictionary).value(forKey: "packageName") as? String else {
                result(false)
                return}
            isAppInstalled(uriSchemName: packageName, result: result)
        default: break
        }
    }
    
    private func launchCredPay(uri: String, result: @escaping FlutterResult) {
        
        if let url = URL(string: uri), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
            result("success")
        }
        else {
            result("fail")
        }
        
    }
    
    private func isAppInstalled(uriSchemName: String, result: @escaping FlutterResult) {
        if let url = URL(string: uriSchemName), UIApplication.shared.canOpenURL(url) {
            result(true)
        }
        else {
            result(false)
        }
        
        
        
    }
}
