//
//  RegisterUserEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/18/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterUserEvent: BaseEventWithUser{
    
    var errorMsg: Error?
  
    weak var delegate: RegisterUserEventDelegate? {
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    var state: RegisterUserEventState = .none
    
    override func async_ProcessEvent() {
        guard let user = self.user, let delegate = self.delegate else{
            
            return
        }
        
        let dispatchQueue = DispatchQueue(label: "com.huyvo.cmpe277.dispatchqueue.registeruserevent")
        
        dispatchQueue.async {
            Logger.log(clzz: "RegisterUserEvent", message: "email:\(user.email) password:\(user.password)")
            let db = FirebaseManager().reference
         
            let table: String
            if user is Patron{
                table = DatabaseInfo.patronTable
            }else{
                table = DatabaseInfo.librarianTable
            }
         
            db?.child(table).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let value = snapshot.value as? Dictionary<String, Any>{
                    if var universityIds = value["universityIds"] as? [String]{
                        if universityIds.contains("\(user.universityId!)"){
                            self.state = .universityIdTaken
                            delegate.error(event: self)
                            
                        }else{
                            Auth.auth().createUser(withEmail: user.email, password: user.password) { (returnUser, error) in
                                if let error = error{
                                    
                                    self.errorMsg = error
                                    self.state = .error
                                    delegate.error(event: self)
                                    
                                }else{
                                    
                                    user.id = returnUser!.uid
                                    
                                    db?.child(table).child(returnUser!.uid)
                                        .setValue(user.dict)
                                    
                                    universityIds.append("\(user.universityId!)")
                                    
                                    db?.child(table).updateChildValues(["universityIds": universityIds])
                                    
                                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                                        
                                        if let error = error{
                                            Logger.log(clzz: "RegisterUserEvent", message: "error")
                                            
                                            self.errorMsg = error
                                            self.state = .error
                                            delegate.error(event: self)
                                        
                                            
                                        }else{
                                            Logger.log(clzz: "RegisterUserEvent", message: "success")
                                            
                                            self.state = .success
                                            delegate.complete(event: self)
                                            
                                        
                                        }
                                    }
                                    
                                }
                                
                                    
                                
                            }
                        }
                    }
                    
                }else{
                    // first user created for application
                    Auth.auth().createUser(withEmail: user.email, password: user.password) { (returnUser, error) in
                        if let error = error{
                       
                            
                            self.errorMsg = error
                            self.state = .error
                            delegate.error(event: self)
                            
                        }else{
                             
                            user.id = returnUser!.uid
                            
                            db?.child(table).child(returnUser!.uid)
                                .setValue(user.dict)
                            
                            db?.child(table).updateChildValues(["universityIds": ["\(user.universityId!)"]])
                            
                            Auth.auth().currentUser?.sendEmailVerification { (error) in
                                
                                if let error = error{
                                    
                                    Logger.log(clzz: "RegisterUserEvent", message: "error")
                                    self.errorMsg = error 
                                    self.state = .error
                                    delegate.complete(event: self)
                                }else{
                                    Logger.log(clzz: "RegisterUserEvent", message: "success")
                                    
                                    
                                    self.state = .success
                                    delegate.complete(event: self)
                                    
                                }
                            }
                            
                        }
                        
                            
                        
                    }
                }
            })
            
        }
            
    }
   
}

enum RegisterUserEventState{
    case emailTaken
    case universityIdTaken
    case success
    case error
    case none
}

protocol RegisterUserEventDelegate: AbstractEventDelegate {
}
