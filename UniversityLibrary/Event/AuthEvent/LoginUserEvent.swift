//
//  LoginUserEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/18/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class LoginUserEvent: BaseEventWithUser{
    
    weak var delegate: LoginUserEventDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }

    var state: LoginUserEventState = .none
    
    
    override func async_ProcessEvent() {
        guard let user = self.user, let delegate = self.delegate else {
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.dispatchqueue.loginuserevent")
        
        queue.async {
            
            Auth.auth().signIn(withEmail: user.email, password: user.password, completion: {(returnUser, error) in
                if let error = error{
                    print(error)
                    delegate.error(event: self)
                    
                }else{
                    if returnUser!.isEmailVerified{
                        self.state = .success
                        delegate.complete(event: self)
                        
                        
                        let email = user.email
                        
                        var tableName = DatabaseInfo.patronTable
                        
                        if (email?.isSJSUEmail())!{
                            tableName = DatabaseInfo.librarianTable
                        }
                        
                        
                        let db = FirebaseManager().reference.child(tableName)
                        
                        db.child(returnUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                            
                            if let value = snapshot.value as? Dictionary<String, Any>{
                                
                                if (email?.isSJSUEmail())!{
                                    let user = Librarian(dict: value)
                                    user.save()
                                    AppDelegate.setLibrarian(user)
                                }else{
                                    let user = Patron(dict: value)
                                    user.save()
                                    AppDelegate.setPatron(user)
                                    
                                }
                                
                                self.state = .success
                                delegate.complete(event: self)
                                
                            }
                        })
                        
                        
                        
                        
                        
                    }else{
                        self.state = .emailNotVerified
                        delegate.complete(event: self)
                    
                    }
             
                }
            })
        }
        
    }
}
protocol LoginUserEventDelegate: AbstractEventDelegate{
    
}

enum LoginUserEventState{
    case userTaken
    case success
    case error
    case none
    case emailNotVerified
   
}
