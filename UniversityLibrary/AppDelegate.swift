//
//  AppDelegate.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/13/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // this is where user is location through out the application
    // to call this user, you need to access UIApplication
    
    var user: User?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Logger.log(clzz: "AppDelegate", message: "didFinisihLaunchingWithOptions")
     
        // set root view controller
        /*
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let root = mainStoryboard.instantiateViewController(withIdentifier: "NavRootViewController") as! NavRootViewController
        self.window?.rootViewController = root
        self.window?.makeKeyAndVisible()
 */
        // start lbrarian storyboard
        
        /*
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Librarian", bundle: nil)
        let root = mainStoryboard.instantiateViewController(withIdentifier: "LibrarianNavViewController") as! LibrarianNavViewController
        self.window?.rootViewController = root
        self.window?.makeKeyAndVisible()
        */
        // end set root view controller
        
        // start patron storyboard
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Patron", bundle: nil)
        let root = mainStoryboard.instantiateViewController(withIdentifier: "PatronNavViewController") as! PatronNavViewController
        self.window?.rootViewController = root
        self.window?.makeKeyAndVisible()
 
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        Logger.log(clzz: "AppDelegate", message: "applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        Logger.log(clzz: "AppDelegate", message: "applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Logger.log(clzz: "AppDelegate", message: "applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Logger.log(clzz: "AppDelegate", message: "applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        Logger.log(clzz: "AppDelegate", message: "applicationWillTerminate")
    
    }

   

}

