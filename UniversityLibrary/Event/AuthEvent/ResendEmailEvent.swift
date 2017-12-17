//
//  ResendEmailEvent.swift
//  UniversityLibrary
//
//  Created by student on 12/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//
import FirebaseAuth
import Firebase
import Foundation

class ResendEmailEvent: AbstractEvent{
    
    var delegate: AbstractEventDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }
    var state: ResendEmailState?
    
    var patron: Patron
    
    init(patron: Patron){
        self.patron = patron
    }
    
    
    func async_ProcessEvent() {
        guard let delegate = self.delegate else {
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.resendemailevent")
        queue.async {
            Auth.auth().currentUser?.sendEmailVerification(completion: {(error) in
                if let _ = error {
                    self.state = .error
                    delegate.error(event: self)
                }else{
                    self.state = .success
                    delegate.complete(event: self)
                }
            
            })
        }
        
        
    }
}

enum ResendEmailState: String{
    case error = "Error"
    case success = "Email resend"
}
