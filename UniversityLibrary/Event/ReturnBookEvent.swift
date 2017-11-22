//
//  ReturnBookEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/21/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class ReturnBookEvent: AbstractEvent{
    
    let patron: Patron
    init(patron: Patron){
        
        self.patron = patron
    }
    
    
    
    
    func async_ProcessEvent() {
        
    }
}


protocol ReturnBookDelegate: AbstractEventDelegate {
    
}

enum ReturnBookState{
    case error
    case success 
}
