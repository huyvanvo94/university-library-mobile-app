//
//  DeleteUserEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/21/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class DeleteUserEvent: AbstractEvent{
    
    let user: User!
    
    weak var delegate: DeleteUserDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    init(patron: Patron){
        self.user = patron
    }
    
    init(librarian: Librarian) {
        self.user = librarian
    }
    
    
    func async_ProcessEvent() {
  
        guard let delegate = self.delegate else{
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.deleteevent")
        queue.async {
            
            
        }
   
    }
}

protocol DeleteUserDelegate: AbstractEventDelegate {
    
}

enum DeleteUserState{
    case error
    case success
}
