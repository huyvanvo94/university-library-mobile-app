//
//  AppDelegate.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/13/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit 
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginUserEventDelegate {

    var window: UIWindow?

    // this is where user is location through out the application
    // to call this user, you need to access UIApplication
    
    static var user: User?

    static func setPatron(_ patron: Patron){
        user = patron
    }
    
    static func setLibrarian(_ librarian: Librarian){
        user = librarian
    }
    
    static func fetchLibrarian() -> Librarian?{
        Logger.log(clzz: "AppDelegate", message: "is Librarian: \(user is Librarian)")
        return user as? Librarian
    }
    
    static func fetchPatron() -> Patron?{
        Logger.log(clzz: "AppDelegate", message: "is Patron: \(user is Patron)")
        return user as? Patron
    }
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Logger.log(clzz: "AppDelegate", message: "didFinisihLaunchingWithOptions")
        FirebaseApp.configure()
     
        UINavigationBar.appearance().tintColor = UIColor.white
        
       
   //   self.goToLibrarian()
        
        
        self.goToMain()
        
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
        
        if let user = AppDelegate.user{
            user.save()
        }
        
        Logger.log(clzz: "AppDelegate", message: "applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Logger.log(clzz: "AppDelegate", message: "applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Logger.log(clzz: "AppDelegate", message: "applicationDidBecomeActive")
        
        //self.goToMain()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        Logger.log(clzz: "AppDelegate", message: "applicationWillTerminate")
    
    }

    
    func goToMain(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let root = mainStoryboard.instantiateViewController(withIdentifier: "NavRootViewController") as! NavRootViewController
        self.window?.rootViewController = root
        self.window?.makeKeyAndVisible()

    }
    

    func goToLibrarian(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Librarian", bundle: nil)
        let root = mainStoryboard.instantiateViewController(withIdentifier: "LibrarianNavViewController") as! LibrarianNavViewController
        self.window?.rootViewController = root
        
        self.window?.makeKeyAndVisible()
    }
   

    func goToPatron(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Patron", bundle: nil)
        let root = mainStoryboard.instantiateViewController(withIdentifier: "PatronNavViewController") as! PatronNavViewController
        self.window?.rootViewController = root
        self.window?.makeKeyAndVisible()
    }
    

    func complete(event: AbstractEvent) {
        
        switch event {
        case let event as LoginUserEvent:
            
            if event.user! is Patron{
                self.goToPatron()
            }else{
                self.goToLibrarian()
            }
            
        default:
            self.goToMain()
        }
    }
 
    
    func error(event: AbstractEvent) {
       
        self.goToMain()
    }
    
    func tryLogin(){
        if let user = User.fetch(){
            Logger.log(clzz: "AppDelegate", message: "Login user with \(user.email) & \(user.password)")
            
            if user.email.isSJSUEmail(){
                
                let librarian = Librarian(email: user.email, password: user.password)
                let event = LoginUserEvent(librarian: librarian)
                event.delegate = self
            
            }else{
                let patron = Patron(email: user.email, password: user.password)
                let event = LoginUserEvent(patron: patron)
                event.delegate = self
            }
        }else{
            Logger.log(clzz: "AppDelegate", message: "try login but going to main")
            self.goToMain()
        }
    }
    
    
}

