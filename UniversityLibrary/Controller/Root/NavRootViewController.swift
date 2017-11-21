//
//  NagRootViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

/**
 * This is the master controller for the application.
 * Any UI must go through this controller first.
 */
class NavRootViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(clzz: "NavRootViewController", message: "viewDidLoad")
        self.goToLoginView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func goToSignUpView(){
        if let signUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController{
            self.pushViewController(signUpView, animated: true)
        }
    }
    
    func goToLoginView(){
        if let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
            self.pushViewController(loginView, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
