//
//  SignoutUserEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/18/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class SignoutUserEvent: BaseEventWithUser{
    
    weak var delegate: AbstractEventDelegate? {
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    var state: SignoutUserState = .none
    
    
    override func async_ProcessEvent() {
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.dispatchqueue.signoutusereevent")
        
        queue.async {
            
            do{
                try Auth.auth().signOut() 
                AppDelegate.user?.signOut()
                
                self.state = .success
                self.delegate?.complete(event: self)
                
            }catch{
                self.state = .error
                self.delegate?.error(event: self)
            }
            
        }
    }
}

protocol SignoutUserDelegate: AbstractEventDelegate {

}

enum SignoutUserState{
    case none
    case success
    case error
}
