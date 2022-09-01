import UIKit
import Flutter
import Firebase
import WebEngage
import webengage_flutter
import AppTrackingTransparency
import AppsFlyerLib

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let paymentChannel = FlutterMethodChannel(name: "fello.in/dev/payments/paytmService",
        binaryMessenger: controller.binaryMessenger)
//        paymentChannel.setMethodCallHandler({
//            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
//               // This method is invoked on the UI thread.
//              switch(call.method){
//                case "launchPaytmDeepLink":
//                  let args = call.arguments
//                  let uri = (args!["url"] as? String)!
//                  self.launchUri(uri: uri, result: result)
//                  return
//                default:
//                  result(FlutterMethodNotImplemented)
//                  return
//              }
//        })
        if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        if(!UserDefaults.standard.bool(forKey: "Notification")) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UserDefaults.standard.set(true, forKey: "Notification")
        }
        WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
          let firebaseAuth = Auth.auth()
            Messaging.messaging().appDidReceiveMessage(userInfo)
            print(userInfo)
          if (firebaseAuth.canHandleNotification(userInfo)){
              completionHandler(.noData)
              return
          } 
      }
    
    // Called when the application sucessfuly registers for push notifications
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AppsFlyerLib.shared().registerUninstall(deviceToken)
    }
    
    private func canLaunch(uri: String) -> Bool {
        let url = URL(string: uri)
        return UIApplication.shared.canOpenURL(url!)
      }

    private func launchUri(uri: String, result: @escaping FlutterResult) -> Bool {
        if(canLaunch(uri: uri)) {
          let url = URL(string: uri)
          if #available(iOS 10, *) {
            UIApplication.shared.open(url!, completionHandler: { (ret) in
                result(ret)
            })
          } else {
            result(UIApplication.shared.openURL(url!))
          }
        }
        return false
      }
}
