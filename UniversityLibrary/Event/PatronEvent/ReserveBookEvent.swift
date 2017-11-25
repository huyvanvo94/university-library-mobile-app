//
//  ReserveBookEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/25/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

/*
 * When a book becomes available, the first person on the waiting list is notified about its availability, and the person is removed from the waiting list. The book is reserved for this person for three days, during which only this person can check out this book. After these three days, the reservation is cancelled, and the next person in the waiting list (if there is any) is notified about the availability, and a three-day reservation is created for him as well. So on and so forth.
 */


class ReserveBookEvent: AbstractEvent{
    
    let patorn: Patron
    let book: Book
    
    var delegate: ReserveBookDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    init(patorn: Patron, book: Book){
        self.patorn = patorn
        self.book = book
    }
    
    // Add users to reserve table
    
    func async_ProcessEvent() {
        
        guard let delegate = self.delegate else {
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.reserverbookevent")
        
        queue.async {
            
            let db = FirebaseManager().reference
            
            db?.child(DatabaseInfo.reserveTable).child(String(self.book.hashKey)).observeSingleEvent(of: .value, with: {(snapshot) in
                
                
                if var value = snapshot.value as? [String: Any]{
                    
                    if var users = value["users"] as? [String]{
                        if users.contains(self.patorn.id!){
                            
                        }else{
                            users.append(self.patorn.id!)
                            
                            db?.child(DatabaseInfo.reserveTable).child(String(self.book.hashKey)).updateChildValues(["users": users])
                            
                        }
                        
                        
                    }else{
                        // is empty
                        var users = [String: Any]()
                        users["users"] = [self.patorn.id!]
                        db?.child(DatabaseInfo.reserveTable).child(String(self.book.hashKey)).updateChildValues(users)
                        
                    }
                    
                }
               
                
            })
            
            
        }
        
    }
    
}

protocol ReserveBookDelegate: AbstractEventDelegate {
    
}




