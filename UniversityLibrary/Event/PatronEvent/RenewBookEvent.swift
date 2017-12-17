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

                    if let _ = value["users"]{
                        
                        self.state = .isFull
                        delegate.error(event: self)
                        
                    }else{
                         db?.child(DatabaseInfo.checkedOutListTable).child(self.book.key).observeSingleEvent(of: .value, with: {(snapshot) in
                            
                            if var value = snapshot.value as? Dictionary<String, Any>{
                                
                                if var users = value["users"] as? Dictionary<String, Any>{
                                    
 
                                    if let user = users[self.patron.id!] as? Dictionary<String, Any>{

                                        if let renewCount = user["renewCount"] as? Int{
                                            
                                            print("renew count")
 
                                            if renewCount < 2{
                                                var transactionInfo = CheckoutBookInfo(patron: self.patron, book: self.book)
                                            
                                                transactionInfo.returnCount = (renewCount + 1)

                                                users[self.patron.id!] = transactionInfo.dict

                                                value["users"] = users


                                                db?.child(DatabaseInfo.checkedOutListTable).child(self.book.key).updateChildValues(value)
                                                
                                                self.state = .success
                                                delegate.complete(event: self)


                                            }else{
                                                self.state = .error
                                                delegate.error(event: self)
                                            }

                                        }

                                        
                                    }else{
                                        self.state = .error
                                        delegate.error(event: self)
                                    }
                                }
                                
                            }
                        })
                        
                        
                        
                    }
                }
                
            })
        }
    }
    
    
    
}


enum RenewBookAction{
  
}

enum RenewBookState{
    case success
    case error
    case renew
    case isFull

}
