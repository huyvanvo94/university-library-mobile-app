
//
//  CheckoutListEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//
import Foundation
import Firebase

// Event class to checkout books
// Should only surport 9 books at a time

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
                      
                                self.checkoutList.patron.booksCheckedOut.append(self.checkoutList.book.id!)
                                self.checkoutList.patron.numberOfBooksCheckoutToday += 1
                                self.checkoutList.patron.totalNumberOfBooksCheckout += 1
                                self.checkoutList.patron.timeStamp()
                            db.child(self.checkoutList.patron.id!).updateChildValues(self.checkoutList.patron.dict)
                                
                                AppDelegate.setPatron(self.checkoutList.patron)
                                
                                DispatchQueue.main.async { 
                                    delegate.complete(event: self)
                                }
                         
                            }
                            
                        })
                        

                        
                    case .contain:

                        Logger.log(clzz: "CheckoutListEvent", message: "contain")
                        delegate.complete(event: self)
                        
                    case .full:
                        delegate.complete(event: self)
                        
                    case .alreadyOnReserve:
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
    // check if wait_list contains a user
    private func canCheckout(completion: @escaping ((Bool) -> () )){
        
        let db = FirebaseManager().reference
        db?.child(DatabaseInfo.waitingListTable).observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? Dictionary<String, Any>{
                if let _ = value["users"] as? Dictionary<String, Any>{
                    completion(false)
                }else{
                    completion(true)
                }
            }
        })
    }
    
    // add user to list
    private func addToList(checkoutList: CheckoutList, completion: ((CheckoutState) -> () )?){
        Logger.log(clzz: "CheckoutListEvent", message: "addToList")
        let db = FirebaseManager().reference.child(DatabaseInfo.checkedOutListTable)
        
        // init database connection
        db.child(self.checkoutList.book.key).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if var value = snapshot.value as? [String: Any]{
           
                // each book must have a numberOfCopies field, else return errpr
                if let _ = value["numberOfCopies"] as? Int{
                 
                    // check if book is on reservation
                    if let reservation = value["reservation"] as? Dictionary<String, Any>{
                        
                        Logger.log(clzz: "CheckoutListEvent", message: "contains reservation")
                        if let duration = reservation["duration"] as? Double{
                            
                            // If a patron is added to the reservation
                            // Only can be on for 3 days
                            // If over 3 days, can checkout book
                            if DateHelper.numberFromLocalToday(dt: duration) > 3{
                                Logger.log(clzz: "CheckoutListEvent", message: "Delete user from reservation")
                                // must delete user from reservation
                                value["reservation"] = nil
                                // clear and update reservation in database
                                db.child(self.checkoutList.book.key).updateChildValues(value)
                                // check if waiting list exists
                                self.canCheckout(completion: {(canCheckoutBook) in
                                    if canCheckoutBook {
                                        self.checkoutPatron(checkoutList: checkoutList, completion: completion)
                                        
                                    }else{
                                        // waiting list exists
                                        self.notifyNextUserFromWaitList(book: self.checkoutList.book)
                                        if let completion = completion{
                                            completion(.full)
                                        }
                                    }
                                })
                                
                            }
                            else{
                                // reservation is still valid, less than 3 days
                                // checkout if user id is same on reservation dictionary
                                
                                if let id = reservation["id"] as? String{
                                    if id == self.checkoutList.patron.id{
                                     
                                        self.checkoutPatron(checkoutList: checkoutList, removeReservation: true, completion: completion)
                                    }else{
                                        
                                        if let completion = completion{
                                            completion(.alreadyOnReserve)
                                        }
                                    }
                                    
                                }else{
                                    if let completion = completion{
                                        completion(.error)
                                    }
                                    
                                }
                                
                            }
                      
                        }else{
                            // no reservation is on checkout list
                            // we can treat normally
                            self.checkoutPatron(checkoutList: checkoutList, completion: completion)
                          
                        }
                    }else{
                        // no reservation is on checkout list
                        // we can treat normally
                        self.checkoutPatron(checkoutList: checkoutList, completion: completion)
                    }
                    
                }else{
                    // error!
                    if let completion = completion{
                        completion(.error)
                    }
                }
                
               
            }
            
        })
        
    }
    
    // main function that adds patron to checkout list 
    private func checkoutPatron(checkoutList: CheckoutList, removeReservation: Bool=false, completion: ((CheckoutState) -> () )?){
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
                            if(removeReservation){
                                value["reservation"] = nil
                            }
                            db.child(self.checkoutList.book.key).updateChildValues(value)
                             // important to update checkoutlist value before notify next user
                            if(removeReservation){
                                self.notifyNextUserFromWaitList(book: self.checkoutList.book)
                            }
                            
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
                        if(removeReservation){
                            value["reservation"] = nil
                        }
                        db.child(checkoutList.book.key).updateChildValues(value)
                        // important to update checkoutlist value before notify next user
                        if(removeReservation){
                            self.notifyNextUserFromWaitList(book: self.checkoutList.book)
                        }
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
    
    // check if there is a user in waiting list
    private func notifyNextUserFromWaitList(book: Book){
        Logger.log(clzz: "ReturnBooksEvent", message: "notifyNextUserFromWaitList")
        let db = FirebaseManager().reference
        
        db?.child(DatabaseInfo.waitingListTable).child(book.key).observeSingleEvent(of: .value, with: {(snapshot) in
            if var value = snapshot.value as? Dictionary<String, Any>{
                if var users = value["users"] as? Dictionary<String, Any>{
                    let firstKey = Array(users.keys)[users.count-1]
                    
                    if let user = users[firstKey] as? Dictionary<String, Any>{
                        
                        users[firstKey] = nil
                        
                        value["users"] = users
                        db?.child(DatabaseInfo.waitingListTable).child(book.key).updateChildValues(value)
                        
                        db?.child(DatabaseInfo.checkedOutListTable).child(book.key).observeSingleEvent(of: .value, with: {(snapshot) in
                            
                            if var value = snapshot.value as? Dictionary<String, Any>{
                                
                                var reservation = [String: Any]()
                                
                                reservation["id"] = user["id"]
                                reservation["duration"] = Date().threeDaysFromNow.timeIntervalSince1970
                                reservation["durationInfo"] = DateHelper.getLocalDate(dt: Date().threeDaysFromNow.timeIntervalSince1970)
                                
                                value["reservation"] = reservation
                                
                                db?.child(DatabaseInfo.checkedOutListTable).child(book.key).updateChildValues(value)
                                
                            }
                        })
                        if let title = book.title{
                            if let email = user["email"] as? String{
                                let message = "\(title) is able to checkout right now for three days"
                                DataService.shared.sendEmail(email: email, message: message, subject: "Hello", completion: nil)
                            }
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
    case alreadyOnReserve
}
