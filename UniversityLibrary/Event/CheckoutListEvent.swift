//
//  CheckoutListEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class CheckoutListEvent: AbstractEvent{
    
    let checkoutList: CheckoutList
    let action: CheckoutAction
    
    var state: CheckoutState?
    
    weak var delegate: CheckoutListDelegate? {
        didSet{
            self.async_ProcessEvent() 
        }
    }
    
    init(checkoutList: CheckoutList, action: CheckoutAction ) {
        self.checkoutList = checkoutList
        self.action = action
    }
    
    func async_ProcessEvent() {
        guard let delegate = self.delegate else{
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.checkoutlistevent")
        queue.async {
            
            switch self.action{
            
            case .add:
                Logger.log(clzz: "CheckoutListEvent", message: "add")
                
                if self.checkoutList.patron.canCheckoutBook{
                    self.addToList(delegate: delegate, checkoutList: self.checkoutList)
                }else{
                    // cannot checkout
                    
                    self.state = .error
                  
                    delegate.error(event: self)
                }
                
    
            default:
                self.deleteFromList(deletegate: delegate, checkoutList: self.checkoutList)
            }
           
 
        }
        
    }
    
    // add user to list
    private func addToList(delegate: CheckoutListDelegate, checkoutList: CheckoutList){
        let db = FirebaseManager().reference.child(DatabaseInfo.checkedOutListTable)
        
        
        db.child(checkoutList.book.key).observe(.value, with: {(snapshot) in
            if var value = snapshot.value as? [String: Any]{
                
                if let numberOfCopies = value["numberOfCopies"] as? Int{
                    
                    let isEmpty = value["isEmpty"] as! Bool
                    
                    if isEmpty{
                        
                        db.child(checkoutList.book.key).updateChildValues(["isEmpty": false])
                        
                        var users = [String: Any]()
                        users["users"] = [checkoutList.patron.id!]
                        
                        db.child(checkoutList.book.key).setValue(users)
                        
                        self.state = .success
                        delegate.complete(event: self)
                    }else{
                        
                        if var users = value["users"] as? Array<String>{
                            if users.count == numberOfCopies{
                                self.state = .full
                                delegate.complete(event: self)
                            }
                            
                            else if users.contains(self.checkoutList.patron.id!){
                                self.state = .contain
                                delegate.complete(event: self)
                            }else{
                                users.append(self.checkoutList.patron.id!)
                                
                                db.child(checkoutList.book.key).updateChildValues(["users": users])
                                
                                self.state = .success
                                self.delegate?.complete(event: self)
                                
                            }
                            
                        }
                    
                    }
                    
                    
                    
                }
                
                /*
                if (let isEmpty = value["isEmpty"]
                
                let isFull = value["isFull"] as! Bool
                
                if isFull{
                    self.state = .full 
                    self.delegate!.complete(event: self)
                }else{
                    let isEmpty = value["isEmpty"] as! Bool
                    
                    if isEmpty{
                        db.child(checkoutList.book.key).updateChildValues(["isEmpty": false])
                        // now add to db
                        
                    }else{
                        
                        // not empty, so no need to change value
                        
                    }
                    
                }*/
                
                db.child(checkoutList.book.key).removeAllObservers()
                
            }
        })
    }
    
    // remove user from list
    private func deleteFromList(deletegate: CheckoutListDelegate, checkoutList: CheckoutList){
        let db = FirebaseManager().reference.child(DatabaseInfo.checkedOutListTable)
        
        db.child(checkoutList.book.key).observe(.value, with: {(snapshot) in
            
            if var value = snapshot.value as? [String: Any]{
                // if list is empty, we know user isn't in the list
                if let isEmpty = value["isEmpty"] as? Bool{
                    
                    if isEmpty{
                        
                    }else{
                        
                        if var users = value["users"] as? [String]{
                         
                            if let index = users.index(of: checkoutList.patron.id!){
                                users.remove(at: index)
                                if users.isEmpty{
                                    db.child(checkoutList.book.key).updateChildValues(["isEmpty": true])
                                }
                                db.child(checkoutList.book.key).updateChildValues(["users": users])
                            }
                          
                        }
                    }
                }
            }
            
            db.child(checkoutList.book.key).removeAllObservers()
        })
        
    }
}

protocol CheckoutListDelegate: AbstractEventDelegate {}

enum CheckoutAction{
    case add
    case delete
}

enum CheckoutState{
    case full
    case error
    case success
    case contain
}
