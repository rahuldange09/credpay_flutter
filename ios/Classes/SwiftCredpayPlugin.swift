import Flutter
import UIKit



public class SwiftCredpayPlugin: NSObject, FlutterPlugin {
    
    private static var methodChannel: FlutterMethodChannel?
    private var flutterResult: FlutterResult?
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        SwiftCredpayPlugin.methodChannel?.setMethodCallHandler(nil)
    }
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let instance = SwiftCredpayPlugin()
        let channel = FlutterMethodChannel(name: "credpay", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        methodChannel = channel
        registrar.addApplicationDelegate(instance)
        UserDefaults.standard.set(false, forKey: "comeFromCredpay")
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "launchCredPay":
            guard let url = (call.arguments as! NSDictionary).value(forKey: "url") as? String else {
                result("failure")
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
        flutterResult = result
        if let url = URL(string: uri), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UserDefaults.standard.set(true, forKey: "comeFromCredpay")
                UIApplication.shared.open(url, options: [:], 
                    completionHandler: {
                        (success) in
                        
                    })
            } else {
                // Fallback on earlier versions
                // let success = UIApplication.shared.openURL(url)
                // result("success")
            }
            
        }
        else {
            result("failure")
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
    public func applicationDidBecomeActive(_ application: UIApplication) {
        let comeFromCredpay = UserDefaults.standard.bool(forKey: "comeFromCredpay")
        if comeFromCredpay {
            UserDefaults.standard.set(false, forKey: "comeFromCredpay")
            flutterResult?("success")
        }else{
            flutterResult?("failure")
        }
    }
    
}
