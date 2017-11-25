//
//  ReturnBookEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/21/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class ReturnBookEvent: AbstractEvent{
    let book: Book
    let patron: Patron
    
    weak var delegate: AbstractEventDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    init(patron: Patron, book: Book){
        self.book = book
        self.patron = patron
    }
    
     
    func async_ProcessEvent() {
        guard let delegate = self.delegate else{
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.returnboookevent")
        queue.async {
            
            let db = FirebaseManager().reference
            
            db?.child(DatabaseInfo.checkedOutListTable).child(self.book.key).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let value = snapshot.value as? [String: Any]{
                    if var users = value["users"] as? Array<String>{
                        if let index = users.index(of: self.patron.id!){
                             
                            users.remove(at: index)
                            
                            db?.child(DatabaseInfo.checkedOutListTable).child(self.book.key).updateChildValues(["users": users])
                            
                            if users.isEmpty{
                                db?.child(DatabaseInfo.checkedOutListTable).child(self.book.key).updateChildValues(["isEmpty": true])
                            }
                            
                        }
                    }
                }
                
            })
            
            
        }
    }
}


protocol ReturnBookDelegate: AbstractEventDelegate {
    
}

enum ReturnBookState{
    case error
    case success 
}
