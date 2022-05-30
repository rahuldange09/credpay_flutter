import Flutter
import UIKit
public class SwiftCredpayPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "credpay", binaryMessenger: registrar.messenger())
        let instance = SwiftCredpayPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method as! String {
            case "launchCredPay":
            let url = (call.arguments as! NSDictionary).value(forKey: "url") as! String
            if UIApplication.shared.canOpenURL(URL(string: url)) {
                UIApplication.shared.open(url)
                result("success")
            }
            else {
                result("fail")
            }
            case "isAppInstalled":
            let packageName = (call.arguments as! NSDictionary).value(forKey: "packageName") as! Bool
            let isAppInstalled = UIApplication.shared.canOpenURL(URL(string: packageName)
            result(isAppInstalled)
            default:
            return nil
        }
    }

}
