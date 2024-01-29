import UIKit
import Firebase
import AppTrackingTransparency
import AppsFlyerLib
import Flutter
import Contacts
import CleverTapSDK
import clevertap_plugin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var resultMyFlutter: FlutterResult?
        

     private var textField = UITextField()

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let paymentChannel = FlutterMethodChannel(name: "methodChannel/deviceData",
                                                  binaryMessenger: controller.binaryMessenger)


        let contactChannel = FlutterMethodChannel(name: "methodChannel/contact", binaryMessenger: controller.binaryMessenger)

        CleverTap.autoIntegrate() // integrate CleverTap SDK using the autoIntegrate option
        CleverTapPlugin.sharedInstance()?.applicationDidLaunch(options: launchOptions)

        paymentChannel.setMethodCallHandler{(call: FlutterMethodCall, result: @escaping
                                             FlutterResult) -> Void in
//            self.resultMyFlutter = result
//            let arguments = call.arguments as? NSDictionary
//            let uri=arguments?["uri"] as? String
//            if uri != nil{
//                switch call.method {
//                case "canLaunch":
//                    result(self.canLaunch(uri: uri!))
//                    return
//                case "launch":
//                    self.launchUri(uri: uri!)
//                    return
//                default:
//                    result(FlutterMethodNotImplemented)
//                    return
//                }
//
//            }
            switch call.method {
            case "getDeviceId":
                self.getUniqueDeviceId(result: result)
            case "isAppInstalled":
                self.isAppInstalled(call, result: result)

            case "getContacts":
                 ContactManager().fetchContacts(result: result)
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        }


        contactChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "getContacts" {
                ContactManager().fetchContacts(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }



            
                
                if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
                
        if(!UserDefaults.standard.bool(forKey: "Notification")) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UserDefaults.standard.set(true, forKey: "Notification")
        }
        
        let action1 = UNNotificationAction(identifier: "action_1", title: "Back", options: [])
        let action2 = UNNotificationAction(identifier: "action_2", title: "Next", options: [])
        let action3 = UNNotificationAction(identifier: "action_3", title: "View In App", options: [])
        let category = UNNotificationCategory(identifier: "CTNotification", actions: [action1, action2, action3], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        
        GeneratedPluginRegistrant.register(with: self)



        makeSecureYourScreen();
        let securityController : FlutterViewController = self.window?.rootViewController as! FlutterViewController
            let securityChannel = FlutterMethodChannel(name: "secureScreenshotChannel", binaryMessenger: securityController.binaryMessenger)
            securityChannel.setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if call.method == "secureiOS" {
                    self.textField.isSecureTextEntry = true
                } else if call.method == "unSecureiOS" {
                    self.textField.isSecureTextEntry = false
                    print("enabling screenshots") 
                }
            })
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func isAppInstalled(_ call: FlutterMethodCall, result: FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
            let appName = args["appName"] as? String {
            let appScheme = "\(appName)://app"
            let appUrl = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appUrl! as URL) {
                result(true)
            } else {
                result(false)
            }
        } else {
            result(FlutterError.init(code: "bad args", message: nil, details: nil))
        }
    }
    
    private func getUniqueDeviceId(result:FlutterResult) {
        result(UIDevice.current.identifierForVendor!.uuidString)
    }
    
    private func canLaunch(uri: String) -> Bool {
       let url: URL? = URL(string: uri)
       if url != nil {
       return UIApplication.shared.canOpenURL(url!)
       }
       return false;
     }

    //  private func loadContacts(completion: @escaping ([String: Any]) -> Void) {
    //      // Your code to load the contacts and put them into a dictionary
    //     let contactManager = ContactManager()
    //     let contacts = contactManager.fetchContacts()
    //     completion(contacts)
    //    }
    
    
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

     // Screenshot Prevent Functions
    private func makeSecureYourScreen() {
       print("disabling screenshots") 
        if (!self.window.subviews.contains(textField)) {
            self.window.addSubview(textField)
            textField.centerYAnchor.constraint(equalTo: self.window.centerYAnchor).isActive = true
            textField.centerXAnchor.constraint(equalTo: self.window.centerXAnchor).isActive = true
            self.window.layer.superlayer?.addSublayer(textField.layer)
            textField.layer.sublayers?.first?.addSublayer(self.window.layer)
        }
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




class ContactManager {
    // func fetchContacts() -> [[String: String]] {
    //     var contactsArray: [[String: String]] = []
    //     let contactStore = CNContactStore()
    //     let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]

    //     do {
    //         try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])) { contact, _ in
    //             let displayName = "\(contact.givenName) \(contact.familyName)"
    //             for phoneNumber in contact.phoneNumbers {
    //                 let phoneNumberString = phoneNumber.value.stringValue
    //                 let contactInfo: [String: String] = [
    //                     "displayName": displayName,
    //                     "phoneNumber": phoneNumberString
    //                 ]
    //                 contactsArray.append(contactInfo)
    //             }
    //         }
    //     } catch {
    //         // Handle error
    //     }

    //     return contactsArray
    // }
    func fetchContacts(result: @escaping FlutterResult) {
    var contactsArray: [[String: Any]] = []
    
    let store = CNContactStore()
    let keysToFetch: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor]
    
    do {
       try store.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])) { contact, _ in
        var contactMap: [String: Any] = [:]
                        let displayName = "\(contact.givenName) \(contact.familyName)"
         for phoneNumber in contact.phoneNumbers {
                    let phoneNumberString = phoneNumber.value.stringValue
                    let contactInfo: [String: String] = [
                        "displayName": displayName,
                        "phoneNumber": phoneNumberString
                    ]
                    contactsArray.append(contactInfo)
                }
      }
      
      result(contactsArray)
    } catch {
      result(FlutterError(code: "ERROR", message: "Failed to get contacts", details: nil))
    }
  }
}
