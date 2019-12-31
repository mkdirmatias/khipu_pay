import Flutter
import UIKit
import khenshin

public class SwiftKhipuPayPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftKhipuPayPlugin()
      
        let defaultChannel = FlutterMethodChannel(name: "khipu_pay", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: defaultChannel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "initialize":
//                let myArguments = call.arguments as? [String : String]
//                let hexaColor = myArguments?["hexaColor"]
              
                KhenshinInterface.initWithBuilderBlock {(builder: KhenshinBuilder?) -> Void in
                    NSLog("init")
                    builder?.apiUrl = "https://khipu.com/app/enc/"
                    builder?.mainButtonStyle = Int(KHMainButtonDefault.rawValue)
//                    builder?.backgroundColor = UIColor()
//                    builder?.barLeftSideLogo = UIImage.init()
                }
                break;
            case "paymentProcess":
                let myArguments = call.arguments as? [String : String]
                let paymentId: String? = myArguments?["paymentId"]
              
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        if !paymentId!.isEmpty {
                            KhenshinInterface.startEngine(withPaymentExternalId: paymentId, userIdentifier: "", isExternalPayment: true, success: { (exitURL: URL?) in
                                result("SUCCESS")
                            }, failure: { (exitURL: URL?) in
                                result("FAILURE")
                            }, animated: false)
                        }else{
                            result("FAILURE")
                        }
                    }
                }
                break;
          default:
              result(FlutterMethodNotImplemented)
        }
    }
}
