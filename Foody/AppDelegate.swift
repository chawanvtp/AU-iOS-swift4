//
//  AppDelegate.swift
//  Foody
//
//  Created by Dhitipong Thivakorakot on 18/3/2561 BE.
//  Copyright © 2561 CS3432. All rights reserved.
//

import UIKit
import Firebase
//import FBSDKLoginKit
//import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // [START initialize_firebase]
        FirebaseApp.configure()
        
        // ETC.
//        FBSDKAppEvents.activateApp()
        
        /** [START initialize_FBSDK Login]
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKLoginManager.renewSystemCredentials { (result, error) in
            print("Result : \(result)")
            print("Error :  \(error)")
        }
 */
        return true
    }
    
}
