//
//  AppDelegate.swift
//  GivBit
//
//  Created by Tallal Javed on 5/7/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift
import AVFoundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        coinbaseoauth.sharedInstnace.getAccessToken(url: url)
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
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
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch {
            print("error avaudiosession")
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
