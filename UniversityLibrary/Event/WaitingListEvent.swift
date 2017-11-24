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
    let action: WaitingListAction
    
    weak var delegate: AbstractEventDelegate? {
        didSet{
            self.async_ProcessEvent() 
        }
    }
    
    init(waitingList: WaitingList, action: WaitingListAction) {
        self.waitingList = waitingList
        self.action = action
    }
    
    func async_ProcessEvent() {
        
        guard let delegate = self.delegate else {
            return
        }
        
        let queue = DispatchQueue(label: "com.huy.vo.cmpe277.waitinglistevent")
        
        queue.async {
            
            switch self.action{
            case .add:
                self.add(delegate: delegate, waitingList: self.waitingList)
            default:
                print("no action")
            }
            
            
        }
    }
    
    private func add(delegate: AbstractEventDelegate, waitingList: WaitingList){
        let db = FirebaseManager().reference.child(DatabaseInfo.waitingListTable)
        
        db.child(waitingList.book.key).observe(.value, with: {(snapshot) in
            
            if let value = snapshot.value as? [String: Any]{
                let isEmpty = value["isEmpty"] as! Bool
                
                if isEmpty{
                    var users = [String: Any]()
                    
                    users["users"] = self.waitingList.patron.id
                    
                    db.child(waitingList.book.key).updateChildValues(["isEmpty": false])
                    db.child(waitingList.book.key).updateChildValues(["users":users])
                }else{
                    if var users = value["users"] as? [String]{
                        if users.contains(waitingList.patron.id!) == false{
                            users.append(waitingList.patron.id!)
                            db.child(waitingList.book.key).updateChildValues(["users": users])
                            
                            
                        }else{
                            
                        }
                    }
                    
                }
        
                
            }else{
                
                
            }
            // kill listeners
            db.child(self.waitingList.book.key).removeAllObservers()
        })
    }
    
    private func delete(){
        
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
}
