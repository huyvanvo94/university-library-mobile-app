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
  
    weak var delegate: RegisterUserEventDelegate?
    
    var state: RegisterUserEventState = .none
    
    override func async_ProcessEvent() {
        guard let user = self.user, let delegate = self.delegate else{
            
            return
        }
        
        let dispatchQueue = DispatchQueue(label: "com.huyvo.cmpe277.dispatchqueue.registeruserevent")
        
        dispatchQueue.async {
            let db = FirebaseManager().reference
            //let key = db?.childByAutoId().key
            
            let table: String
            if user is Patron{
                table = DatabaseInfo.patronTable
            }else{
                
                table = DatabaseInfo.librarianTable
                
            }
          
            Auth.auth().createUser(withEmail: user.email, password: user.password) { (returnUser, error) in
                if let error = error{
                    print(error)
                    self.state = .error
                    delegate.error(event: self)
                    
                }else{
                    
                
                    db?.child(table).child(returnUser!.uid)
                        .setValue(user.dict)
                    
                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                       
                        if let error = error{
                            
                        }else{
                            
                        }
                    }
                    
                    
                    self.state = .success
                    delegate.complete(event: self)
                    
                } 
                
            }
            /*
            let table: String
            
            if user is Patron{
                table = DatabaseInfo.patronTable
            }else{
                table = DatabaseInfo.librarianTable
            }
            
            self.containsEmail(user: user, completion: { doesContainEmail in
                if !doesContainEmail{
                    // set current user to use
                    (UIApplication.shared.delegate as! AppDelegate).user = user
                    
                    self.insertToDb(table: table, key: key!, user: user)
                    self.state = .success
                    delegate.complete(event: self)
                   
                }else{
                    self.state = .error 
                    delegate.complete(event: self)
                }
            })*/
            
            
        }
    }
    
    func insertToDb(table: String, key: String, user: User){
   
        let db = FirebaseManager().reference
        // add user first
        db?.child(table).child(key).setValue(user.dict)
        // denormalization
        // add data for quick access for future CRUD operations 
        db?.child(DatabaseInfo.registerEmailTable).child(user.emailKey).setValue(["id": key])
        
    }
    
    func containsEmail(user: User, completion: @escaping ( (Bool) ->Void )){
        let db = FirebaseManager().reference
        let ref = db?.child(DatabaseInfo.registerEmailTable)
        
        ref?.observeSingleEvent(of: .value, with: {(snapshot) in
            // contains child in database
            if snapshot.hasChild(user.emailKey){
                completion(true)
            }else{
                completion(false)
            }
        })
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
