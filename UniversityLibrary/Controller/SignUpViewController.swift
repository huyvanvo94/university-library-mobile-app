//
//  SignUpViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var studentIdTextField: UITextField!
    
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
            return
        }
        
        activityIndicatorView.startAnimating()
        
        print("email: \(email) password: \(password) studentId: \(universityId)")
        
        // if ends with "@sjsu.edu" user is consider a librarian
        if email.hasSuffix("@sjsu.edu"){
            let user = Librarian(email: email, password: password, universityId: universityId)
          
            let handler = UserHandler(lib: user)
            handler.async_RegisterUser(completion: handleRegisterUser)
        }else{
            let user = Patron(email: email, password: password, universityId: universityId)
            let handler = UserHandler(patron: user)
            handler.async_RegisterUser(completion: handleRegisterUser)
            
        }
    }
    
    func handleRegisterUser(code: SignUpEnum){
        activityIndicatorView.stopAnimating()
        switch code {
        case .emailTaken:
            self.showToast(message: "Email Taken!")
            self.emailTextField.text = ""
            
        case .universityIdTaken:
            self.showToast(message: "University Id Taken!")
            self.studentIdTextField.text = ""
        default:
            if let validView = self.storyboard?.instantiateViewController(withIdentifier: "ValidationViewController") as? ValidationViewController{
                self.navigationController?.pushViewController(validView, animated: true)
            }
           
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
    
    fileprivate lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        
        // Set Center
        var center = self.view.center
        if let navigationBarFrame = self.navigationController?.navigationBar.frame {
            center.y -= (navigationBarFrame.origin.y + navigationBarFrame.size.height)
        }
        activityIndicatorView.center = center
        
        self.view.addSubview(activityIndicatorView)
        return activityIndicatorView
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
