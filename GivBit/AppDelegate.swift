//
//  AppDelegate.swift
//  GivBit
//
//  Created by Tallal Javed on 5/7/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift
import FirebaseMessaging
import FirebaseFunctions

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("application function ran - appDelegate")
        coinbaseoauth.sharedInstnace.getAccessToken(url: url)
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("didFinishLaunching")
        // Called to configure the firebase framework
        FirebaseApp.configure()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        // check if firebase user is logged in and load the respective uiscreens
        if Auth.auth().currentUser != nil{
            // check if the user has coinbase linked
            
            // User is signed in... let the general flow go
            let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            self.window?.rootViewController = mainStoryBoard.instantiateInitialViewController()
            self.window?.makeKeyAndVisible()
            
        }else{
            // User is not signedf in... load the login UI
        }
        
        // set the theme
        ColorsHelper.setTheme1()
        
        // set the keybaord config
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // if user is already logged in... jusr repopulate from db
        if Auth.auth().currentUser != nil{
            FirestoreHelper.sharedInstnace.getUserWithUUID(universalUserID: (Auth.auth().currentUser?.uid)!) { (user, success) in
                // if user is already logged in before.. it will just populate the gbuser from db cache
            }
        }
        
        registerForNotications(application)
        
        
        return true
    }
    
    func registerForNotications(_ application: UIApplication){
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        GlobalVariables.Checked_Already = "FALSE"
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("didReceiveRemoteNotification1")
        
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("1 Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification2")
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("2 Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        //_ = UNNotificationAction(identifier: "like", title: "Like", options: [])
        
        
        
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
}




// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    //THIS IS CALLED WHEN APP IS OPEN AND THEY GET A NOTIFICATION ****
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("3 Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        if let notificationType = userInfo["notificationType"]{
            print("got notificationType")
            if (notificationType as! String == "VENDOR PAID NOTIFICATION"){
                print("got Vendor Paid Notification")
                var invoiceId = userInfo["invoiceId"] as! String
                var invoiceStatus = userInfo["invoiceStatus"] as! String

                let paidNotificationDict:[String: String] = ["invoiceId": invoiceId as! String, "invoiceStatus": invoiceStatus as! String]
                //TO DO - add status, paid or not to know if user canceled invoice or not
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rececivedInvoiceNotification"), object: nil, userInfo: paidNotificationDict)
                
            }
        }
        
        //Show the in app notification if the user has the app open
        completionHandler([.alert, .badge, .sound])
    }
    
    
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        let functions = Functions.functions()
        functions.httpsCallable("updateUserRegistration").call(["registrationToken": fcmToken]) { (result, error) in
            if error != nil{
                print("Error performing updateUserRegistration function \(String(describing: error?.localizedDescription))")
            }else{
                print(result?.data ?? "")
                let data = result?.data as! [String: Any]
                if data["error"] != nil{
                    print("error - updateUserRegistration")
                }else{
                    
                }
            }
        }
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
    
    
}

struct GlobalVariables {
    static var Coinbase_Linkage_Status = ""
    static var Checked_Already = "FALSE"
}

