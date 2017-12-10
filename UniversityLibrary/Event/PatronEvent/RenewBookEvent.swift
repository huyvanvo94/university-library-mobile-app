//
//  RenewBookEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/29/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class RenewBookEvent: AbstractEvent{
    
    var state: RenewBookState?
    
    weak var delegate: AbstractEventDelegate? {
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    let book: Book
    let patron: Patron
    
    init(book: Book, patron: Patron){
        self.book = book
        self.patron = patron
    }
    
    func async_ProcessEvent() {
        guard let delegate = self.delegate else {
            return
        }
        
        let queue = DispatchQueue(label: "com.huy.vo.cmpe277.renewbookevent")
        
        queue.async {
  
            let db = FirebaseManager().reference
            
            db?.child(DatabaseInfo.waitingListTable).child(self.book.key).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let value = snapshot.value as? Dictionary<String, Any>{
                    
                }
                
            })
        }
    }
    
    
    
}

protocol RenewBookEventDelegate: AbstractEventDelegate {
    
}

enum RenewBookAction{
  
}

enum RenewBookState{
    case success
    case error
    case renew
}
