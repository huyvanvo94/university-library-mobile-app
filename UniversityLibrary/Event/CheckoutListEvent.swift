//
//  CheckoutListEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class CheckoutListEvent: AbstractEvent{
    
    let patorn: Patron
    let book: Book
    
    weak var delegate: CheckoutListDelegate?
    
    init(patorn: Patron, book: Book ) {
        self.patorn = patorn
        self.book = book
    }
    
    func async_ProcessEvent() {
        guard let delegate = self.delegate else{
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.checkoutlistevent")
        queue.async {
            
        }
        
    }
}

protocol CheckoutListDelegate: AbstractEventDelegate {}

enum CheckoutState{
    case full
    case error
    case success 
}
