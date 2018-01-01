//
//  SignoutUserEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/18/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class SignoutUserEvent: AbstractEvent{
    
    weak var delegate: AbstractEventDelegate? {
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    let user: User
    
    init(user: User){
        self.user = user
    }
    
    var state: SignoutUserState = .none
    
    func async_ProcessEvent() {
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.dispatchqueue.signoutusereevent")
        
        queue.async {
           
            self.user.signout()
          
            do{
                try Auth.auth().signOut()  
                
                DispatchQueue.main.async {
                    self.state = .success
                    self.delegate?.complete(event: self) 
                }
                
            }catch{
                DispatchQueue.main.async {
                    self.state = .error
                    self.delegate?.error(event: self)
                    
                }
            } 
        }
    }
}


enum SignoutUserState{
    case none
    case success
    case error
}
