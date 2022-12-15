import UIKit
import Firebase
import WebEngage
import webengage_flutter
import AppTrackingTransparency
import AppsFlyerLib
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var resultMyFlutter: FlutterResult?
        
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let paymentChannel = FlutterMethodChannel(name:"fello.in/dev/notifications/channel/tambola",
                                                  binaryMessenger: controller.binaryMessenger)
        paymentChannel.setMethodCallHandler{(call: FlutterMethodCall, result: @escaping
                                             FlutterResult) -> Void in
            self.resultMyFlutter = result
            let arguments = call.arguments as? NSDictionary
            let uri=arguments?["uri"] as? String
            if uri != nil{
                switch call.method {
                case "canLaunch":
                    result(self.canLaunch(uri: uri!))
                    return
                case "launch":
                    self.launchUri(uri: uri!)
                    return
                default:
                    result(FlutterMethodNotImplemented)
                    return
                }
            }
        }
            
                
                if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
                
        if(!UserDefaults.standard.bool(forKey: "Notification")) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UserDefaults.standard.set(true, forKey: "Notification")
        }
        WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    private func canLaunch(uri: String) -> Bool {
       let url: URL? = URL(string: uri)
       if url != nil {
       return UIApplication.shared.canOpenURL(url!)
       }
       return false;
     }
    
    
    private func launchUri(uri: String) -> Bool {
        if(canLaunch(uri: uri)) {
          let url = URL(string: uri)
          if #available(iOS 10, *) {
            UIApplication.shared.open(url!, completionHandler: { (ret) in
                self.resultMyFlutter!(ret)
            })
          } else {
              self.resultMyFlutter!(UIApplication.shared.openURL(url!))
          }
        }
        return false
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
}
