//
//  AbstractEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/18/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

protocol AbstractEvent{
  
    func async_ProcessEvent()
}

protocol AbstractEventDelegate: class {
    func complete(event: AbstractEvent)
    func error(event: AbstractEvent)
}


class BaseEventWithUser: AbstractEvent{
    
    var user: User?
    
    init(librarian: Librarian){
        self.user = librarian
    }
    
    init(patron: Patron){
        self.user = patron
    }
    
    func async_ProcessEvent() {
        
    }
}
 
