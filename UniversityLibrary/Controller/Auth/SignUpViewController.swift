//
//  SignUpViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit
import MessageUI

class SignUpViewController: BaseViewController, RegisterUserEventDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var studentIdTextField: UITextField!
    
    @IBOutlet weak var resendEmail: UIButton!
    
    var email: String?
    var password: String?
    
    override func loadView() {
        super.loadView()
        
        self.title = "Sign Up"
 
    }
    
    private func clearText(){
        studentIdTextField.text = ""
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.studentIdTextField.delegate = self
        
        self.studentIdTextField.keyboardType = .numberPad
        self.emailTextField.keyboardType = .emailAddress
        
        self.hideKeyboardWhenTappedAround()
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let universityId = Int(studentIdTextField.text!) else{
            self.alertMessage(title: "Error", message: "All text fields required!")
            return
        }
        
        if studentIdTextField.text?.characters.count != 6{
            
            self.alertMessage(title: "Error", message: "Invalid University Id")
            return 
        }
        
        
        super.activityIndicatorView.startAnimating()
        
        print("email: \(email) password: \(password) studentId: \(universityId)")
        
        // if ends with "@sjsu.edu" user is consider a librarian
        if email.isSJSUEmail(){
            let user = Librarian(email: email, password: password, universityId: universityId)
            let event = RegisterUserEvent(librarian: user)
            event.delegate = self
         
        }else{
            let user = Patron(email: email, password: password, universityId: universityId)
            let event = RegisterUserEvent(patron: user)
            event.delegate = self
          
        }
        
        
    }
    
    func handleRegisterUser(event: RegisterUserEvent){
        super.activityIndicatorView.stopAnimating()
        switch event.state {
        case .error:
            self.alertMessage(title: "Error", message: "Oops, something went wrong")
            
        case .emailTaken: 
            self.alertMessage(title: "Error", message: "Email taken!")
            self.emailTextField.text = ""
            
        case .universityIdTaken:
            self.alertMessage(title: "Error", message: "Univesrity Id Taken")
            
            self.studentIdTextField.text = ""
        default:
            self.clearText()
            self.email = event.user?.email
            self.password = event.user?.password
            
            let email = event.user!.email!
            let alert = UIAlertController(title: "Validation", message: "Validation code sent to \(email)", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: .destructive, handler: handleValidation)
          
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
           
   
            /*
            if let validView = self.storyboard?.instantiateViewController(withIdentifier: "ValidationViewController") as? ValidationViewController{
                self.navigationController?.pushViewController(validView, animated: true)
            }
            */
            
           
        }
    }
    
    func handleValidation(_ alertAction: UIAlertAction!) -> Void{
       
        resendEmail.isHidden = false
    }

    @IBAction func resendEmailClick(_ sender: UIButton) {
        if let email = self.email, let password = self.password{
            let patron = Patron(email: email, password: password)
            let event = ResendEmailEvent(patron: patron)
            event.delegate = self
        }
        
    }
    
    
    // UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("TextField did begin editing method called")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("TextField did end editing method called\(textField.text!)")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //print("TextField should begin editing method called")
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //print("TextField should clear method called")
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //print("TextField should end editing method called")
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //print("While entering the characters this method gets called")
       
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("TextField should return method called")
        self.view.endEditing(true)
        return true
    }
    
    
    func complete(event: AbstractEvent){
        print("Event complete")
        
        switch event {
        case let event as RegisterUserEvent:
            
            
            
            event.delegate = nil
           
            self.handleRegisterUser(event: event)
        case let event as ResendEmailEvent:
            self.alertMessage(title: "Hey!", message: (event.state?.rawValue)!)
            
        default:
            print("No action taken")
        }
        
    }
    func error(event: AbstractEvent){
        super.activityIndicatorView.stopAnimating()
        print("Event error")
        
        switch event {
        case let event as RegisterUserEvent:
            if event.state == .universityIdTaken{
               
                self.alertMessage(title: "Error", message: "university id is taken")
            }else if event.state == .emailTaken{
                // release to memory
                event.delegate = nil
                self.alertMessage(title: "Error", message: "email is taken!")
            }else{
              //  self.showToast(message: "error!")
                if let errorMsg = event.errorMsg{
                    super.alertMessage(title: "Error", message: errorMsg.localizedDescription)
                }
            }
            
        case let event as ResendEmailEvent:
            self.alertMessage(title: "Hey!", message: (event.state?.rawValue)!)
           
        default:
            print("No action taken")
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
