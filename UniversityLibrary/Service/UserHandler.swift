//
//  UserHandler.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit

class UserHandler{

    let user: User!
    
    init(patron: Patron) {
        self.user = patron
    }
    
    init(lib: Librarian){
        self.user = lib 
    }
    
    func async_RegisterUser(completion: ((SignUpEnum)-> Void)?){
    
        let dispatchQueue = DispatchQueue(label: "com.huyvo.cmpe277.dispatchqueue.registeruser")
        dispatchQueue.async {
            let db = FirebaseManager().reference
            
        
            let key = db?.childByAutoId().key
            
            self.user.id = key
            
            if self.user is Patron{
                self.containsEmail(user: self.user, completion:{ doesContainEmail in
                    if !doesContainEmail{
                        (UIApplication.shared.delegate as! AppDelegate ).user = self.user
                        
                        self.insertToDb(table: DatabaseInfo.patronTable, key: key!)
                        
                        if let completion = completion{
                           completion(.success)
                        }
                    }else{
                        if let completion = completion{
                            completion(.emailTaken)
                        }
                    }
                })
            }else{
               
                self.containsEmail(user: self.user, completion:{ doesContainEmail in
                    if !doesContainEmail{
                         (UIApplication.shared.delegate as! AppDelegate).user = self.user
                        
                        self.insertToDb(table: DatabaseInfo.librarianTable, key: key!)
                        
                        if let completion = completion{
                            completion(.success)
                        }
                    }else{
                        if let completion = completion{
                            completion(.emailTaken)
                        }
                    }
                })
               
                
                /*
                ref?.observe(.value, with: {
                    snapshot in
                 
                    if let dict = snapshot.value as? NSDictionary{
                        for (_, user) in dict{
                            if let user = user as? Dictionary<String, Any>{
                                print(user)
                            }
                        }
                    }
                    
                })*/
                
                
            }
        }
    }
    
    func insertToDb(table: String, key: String){
        let db = FirebaseManager().reference
        
        db?.child(table).child(key).setValue(self.user.dict)
        
        db?.child(DatabaseInfo.registerEmailTable).child(self.user.emailKey).setValue(["id": key])
        
    }
    
    func containsEmail(user: User, completion: @escaping ( (Bool) ->Void )){
        let db = FirebaseManager().reference
        let ref = db?.child(DatabaseInfo.registerEmailTable)
        
        ref?.observeSingleEvent(of: .value, with: {(snapshot) in
            // contains child in database
            if snapshot.hasChild(self.user.emailKey){
                completion(true)
            }else{
                completion(false)
            }
        })
    }
}

enum SignUpEnum{
    case emailTaken
    case universityIdTaken
    case success
}

