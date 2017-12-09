
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
    
    var transactionInfo: CheckoutBookInfo?
    
    let checkoutList: CheckoutList
         var state: CheckoutState?
    
    weak var delegate: AbstractEventDelegate? {
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    init(checkoutList: CheckoutList ) {
        self.checkoutList = checkoutList
    
         
    }
    
    func async_ProcessEvent() {
    
        guard let delegate = self.delegate else{
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.checkoutlistevent")
        queue.async {
           
            if self.checkoutList.patron.canCheckoutBook{
                
       
                self.addToList(checkoutList: self.checkoutList, completion: {(state) in
                    
                    self.state = state
                    
                    switch state{
                        
                    case .success:

                        Logger.log(clzz: "CheckoutListEvent", message: "success")
                        
                        let db = FirebaseManager().reference.child(DatabaseInfo.patronTable)
                        
                        db.child(self.checkoutList.patron.id!).observeSingleEvent(of: .value, with: {(snapshot) in
                            
                            
                            if let _ = snapshot.value as? [String: Any]{
                                // update patron
                                Logger.log(clzz: "CheckoutListEvent", message: "Update books")
                      
                                self.checkoutList.patron.booksCheckedOut.append(self.checkoutList.book.key)
                                self.checkoutList.patron.totalNumberOfBooksCheckout += 1
                                self.checkoutList.patron.timeStamp()
                                
                                db.child(self.checkoutList.patron.id!).updateChildValues(self.checkoutList.patron.dict)
                                
                                AppDelegate.setPatron(self.checkoutList.patron)
                                delegate.complete(event: self)
                            }
                            
                        })
                        

                        
                    case .contain:

                        Logger.log(clzz: "CheckoutListEvent", message: "contain")
                        delegate.complete(event: self)
                        
                    case .full:
                        delegate.complete(event: self)
                    default:
                        delegate.error(event: self)
                    }
                })
            }else{
                // cannot checkout
                
                self.state = .error
                
                delegate.error(event: self)
            }
        }
        
    }
    
    // add user to list
    private func addToList(checkoutList: CheckoutList, completion: ((CheckoutState) -> () )?){
        Logger.log(clzz: "CheckoutListEvent", message: "addToList")
        let db = FirebaseManager().reference.child(DatabaseInfo.checkedOutListTable)
        
        
        db.child(self.checkoutList.book.key).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if var value = snapshot.value as? [String: Any]{
                if let numberOfCopies = value["numberOfCopies"] as? Int{
                    
                    if var users = value["users"] as? Dictionary<String, Any>{
                        
                        if users[self.checkoutList.patron.id!] != nil{
                            Logger.log(clzz: "CheckoutListEvent", message: "already checked out")
        
                            if let completion = completion{
                                completion(.contain)
                            }
                        }
                        else if users.count == numberOfCopies{
                         
                            if let completion = completion{
                                completion(.full)
                            }

                            Logger.log(clzz: "CheckoutListEvent", message: "Is Full")
                        }else{
                            
                            let checkoutInfo = CheckoutBookInfo(patron: self.checkoutList.patron, book: self.checkoutList.book)
                           
                            
                          
                            users[self.checkoutList.patron.id!] = checkoutInfo.dict
                            
                            value["users"] = users
                            db.child(self.checkoutList.book.key).updateChildValues(value)
 
                            if let completion = completion{
                                print("success")
                                
                                DataService.shared.confirmCheckout(
                                    bookInfo: checkoutInfo.bookInfo,
                                    email: checkoutInfo.email,
                                    transactionTime: checkoutInfo.transactionTime,
                                    dueDate: checkoutInfo.dueDate, completion: {(success) in
                                        
                                        if success{
                                            
                                            print("success")
                                            
                                        }else{
                                            print("error")
                                            
                                        }
                                       
                                })
                            
                                 
                                self.transactionInfo = checkoutInfo
                                completion(.success)
                            }


                        
                            
                        }
                    }else{
                        Logger.log(clzz: "CheckoutListEvent", message: "checkout")
                        
                        let checkoutInfo = CheckoutBookInfo(patron: self.checkoutList.patron, book: self.checkoutList.book)
                        
                        let user = checkoutInfo.dict
                        
                        value["users"] = [self.checkoutList.patron.id! : user]
                        
                        db.child(checkoutList.book.key).updateChildValues(value)

 
                        if let completion = completion{
                            
                            DataService.shared.confirmCheckout(
                                bookInfo: checkoutInfo.bookInfo,
                                email: checkoutInfo.email,
                                transactionTime: checkoutInfo.transactionTime,
                                dueDate: checkoutInfo.dueDate, completion: {(success) in
                                    
                                    if success{
                                        
                                        print("success")
                                        
                                    }else{
                                        print("error")
                                        
                                    }
                            })
                            
                            
                            self.transactionInfo = checkoutInfo
                            completion(.success)
                        }
 
                    }
                    
                }
            }
            
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
