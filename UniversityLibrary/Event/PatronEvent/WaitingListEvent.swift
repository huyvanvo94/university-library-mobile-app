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
    
    var state: WaitingListState?
  
    let waitingList: WaitingList
 
    
    weak var delegate: AbstractEventDelegate? {
        didSet{
            self.async_ProcessEvent() 
        }
    }
    
    init(waitingList: WaitingList) {
        self.waitingList = waitingList
        
    }
    
    func async_ProcessEvent() {
        
        guard let delegate = self.delegate else {
            return
        }
        
        let queue = DispatchQueue(label: "com.huy.vo.cmpe277.waitinglistevent")
        
        queue.async {
           
            
            self.add(delegate: delegate, waitingList: self.waitingList)
          
            
        }
    }
    
    private func add(delegate: AbstractEventDelegate, waitingList: WaitingList){
        let db = FirebaseManager().reference.child(DatabaseInfo.waitingListTable)
        
        db.child(self.waitingList.book.key).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let value = snapshot.value as? [String: Any]{

                // not empty
                if var users = value["users"] as? Dictionary<String, Any> {
                    if users[self.waitingList.patron.id!] == nil{
                       
                        users[self.waitingList.patron.id!] = self.waitingList.dict
                        
                        db.child(waitingList.book.key).updateChildValues(["users": users])

                        DispatchQueue.main.async {
                            
                        
                            self.state = .success
                            delegate.complete(event: self)
                        }

                    }else{
                        
                        DispatchQueue.main.async {
                            self.state = .duplicate
                        
                            delegate.complete(event: self)
                        }
                    }

                }else{
                    
                    let user = [self.waitingList.patron.id!:self.waitingList.dict]

                    var users = [String: Any]()
                    
                    // add as string array
                    users["users"] = user
                    
                    // start update child values
                    db.child(self.waitingList.book.key).updateChildValues(users)
                    // end uddate child values
                    
                    DispatchQueue.main.async {
                        
                     
                        self.state = .success
                        delegate.complete(event: self)
                        
                    }
                    
                }
                
            }else{
                
                DispatchQueue.main.async {
                    self.state = .error
                    delegate.error(event: self)
                }
                
            } 
        })
    }
 
}

protocol WaitingListDelegate: AbstractEventDelegate {
    
}

enum WaitingListAction{
    case add
    case delete
}

enum WaitingListState{
    case success
    case error
    case duplicate
}
