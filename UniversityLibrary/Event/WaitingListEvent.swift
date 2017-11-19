//
//  WaitingListEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class WaitingListEvent: AbstractEvent{
  
    let waitingList: WaitingList
    
    weak var delegate: WaitingListDelegate?
    
    init(waitingList: WaitingList) {
        self.waitingList = waitingList
    }
    
    func async_ProcessEvent() {
        
        let queue = DispatchQueue(label: "com.huy.vo.cmpe277.waitinglistevent")
        
        queue.async {
            
            let db = FirebaseManager().reference.child(DatabaseInfo.waitingListTable)
            
            db.child(self.waitingList.book.key).observe(.value, with: {(snapshot) in
                
                if var value = snapshot.value as? [String: Any]{
                    
                    if let isEmpty = value["isEmpty"] as? Bool{
                        if isEmpty{
                            let users = [self.waitingList.patron.id!]
                            
                            db.child(self.waitingList.book.key).updateChildValues(["isEmpty": false])
                            db.child(self.waitingList.book.key).updateChildValues(["users":users])
                            
                        }else{
                            if var users = value["users"] as? [String]{
                                
                                if users.contains(self.waitingList.patron.id!) == false{
                                   
                                    users.append(self.waitingList.patron.id!)
                                    db.child(self.waitingList.book.key).updateChildValues(["users": users])
                                }
                            }
                        }
                    }
                     
                }else{
                    
                
                }
                // kill listeners
                db.child(self.waitingList.book.key).removeAllObservers()
            })
        }
    }
}

protocol WaitingListDelegate: AbstractEventDelegate {
    
}

enum WaitingListState{
    case success
    case error
}
