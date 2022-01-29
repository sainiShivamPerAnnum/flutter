import UIKit
import Flutter
import Firebase
import WebEngage
import webengage_flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
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
          }  b
      }
}
