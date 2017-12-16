//
//  LoginViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: BaseViewController, LoginUserEventDelegate{

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func loadView() {
        super.loadView()
        self.title = "Login"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.tryLogin()
       
        
      
        self.emailAddressTextField.keyboardType = .emailAddress
        self.passwordTextField.isSecureTextEntry = true
    
        self.hideKeyboardWhenTappedAround() 
 
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func login(_ sender: UIButton) {
        print("LoginViewController login")
        
        guard let email = self.emailAddressTextField.text, let password = self.passwordTextField.text else{
            self.showToast(message: "All field required")
            return
        }
        
        if email.isValidEmail(){
            // is librian
            if email.isSJSUEmail(){
                let user = Librarian(email: email, password: password )
                
                let event = LoginUserEvent(librarian: user)
                event.delegate = self
            // is patron
            }else{
                let user = Patron(email: email, password: password)
                let event = LoginUserEvent(patron: user)
                event.delegate = self
               
            }
            
        }
        
    }
    
    @IBAction func goToSignupView(_ sender: UIButton) {
        goToSignupView()
    }
    
    func goToSignupView(){
        if let signUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController{
      
            self.navigationController?.pushViewController(signUpView, animated: true)
        }
    }
    
    func complete(event: AbstractEvent) {
       
        switch event {
        case let event as LoginUserEvent:
            handleLoginEvent(event: event)
            
            
        default:
            print("No action taken")
        }
    }
    
    func handleLoginEvent(event: LoginUserEvent){
        switch event.state{
            
        case LoginUserEventState.emailNotVerified:
            self.showToast(message: "Email Not Verified")
             
            
        case LoginUserEventState.success:
            
            if event.user! is Patron{
                goToPatronStoryboard()
                
            }else{
                goToLibrarianStoryboard()
            }
            
        default:
            print("No action taken")
        }
    }
 
    
    func error(event: AbstractEvent) {
        print("error")
        
        switch event {
        case let event as LoginUserEvent: 
            self.showToast(message: "Invalid email or password")
      
        default:
            print("No action taken")
        }
    }
    
    func goToPatronStoryboard(){
        let storyboard = UIStoryboard(name: "Patron", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PatronNavViewController") as? PatronNavViewController{
            present(vc, animated: true, completion: nil)
        }
    }
    
    func goToLibrarianStoryboard(){
        let storyboard = UIStoryboard(name: "Librarian", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "LibrarianNavViewController") as? LibrarianNavViewController{
            present(vc, animated: true, completion: nil)
        }
        
    }
 
    
    func tryLogin(){
     
        if let user = User.fetch(){
            Logger.log(clzz: "AppDelegate", message: "Login user with \(user.email) & \(user.password)")
            
            if user.email.isSJSUEmail(){
                
                let librarian = Librarian(email: user.email, password: user.password)
                let event = LoginUserEvent(librarian: librarian)
                event.loginFromLocal = true
                event.delegate = self
                
            }else{
                let patron = Patron(email: user.email, password: user.password)
                let event = LoginUserEvent(patron: patron)
                event.loginFromLocal = true
                event.delegate = self
            }
            
        }
    }
    

}
