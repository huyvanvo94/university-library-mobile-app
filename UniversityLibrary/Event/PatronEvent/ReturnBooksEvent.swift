//
//  ReturnBooksEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Foundation
import Firebase

class ReturnBooksEvent: AbstractEvent{
    var books: [Book]
    let patron: Patron
    var state: ReturnBooksState?
    
    weak var delegate: AbstractEventDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    init(patron: Patron, books: [Book]){
        self.books = books
        self.patron = patron
    }
    
    
    func async_ProcessEvent() {
        guard let delegate = self.delegate else{
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.returnbooksevent")
        queue.async {
         
            if self.books.count > 9{
                self.state = .overflow
                delegate.complete(event: self)
                
            }else{
                
                let helper = ReturnBooksHelper(event: self)
                helper.doReturn()
                
            }
            
        }
    }
    
    func email(list: [ReturnBookInfo]){
        
        Logger.log(clzz: "ReturnBooksEvent", message: "email")
       
        DataService.shared.returnConfirmationTransaction(data: ReturnBookInfo.convertToArrayString(books: list), email: self.patron.email!, completion: { (success) in
            
            if (success){
                 
                Logger.log(clzz: "ReturnBooksEvent", message: "success")
                self.state = .success
                self.delegate?.complete(event: self)
              
            }else{
                Logger.log(clzz: "ReturnBooksEvent", message: "error")
                self.state = .error
                self.delegate?.error(event: self)
                
            }
            
        })
    }
    
    class ReturnBooksHelper{
        
        let event: ReturnBooksEvent
        
        var returnBooksInfo = [ReturnBookInfo]()
        
        init(event: ReturnBooksEvent){
            self.event = event
        }
        
        func doReturn(){
            if self.event.books.isEmpty{
   
                event.email(list: self.returnBooksInfo)
                event.state = .success
                
                if let delegate = self.event.delegate{
                    delegate.complete(event: event)
                }
                return
            }
            
            let current = event.books.popLast()!
            
            self.doReturn(book: current)
            
        }
        
        private func doReturn(book: Book){
            let db = FirebaseManager().reference
            
            db?.child(DatabaseInfo.checkedOutListTable).child(book.key).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if var value = snapshot.value as? [String: Any]{
                    if var users = value["users"] as? Dictionary<String, Any>{
                        
                        if var user = users[self.event.patron.id!] as? Dictionary<String, Any>{
                       
                            let dueDateTimeInterval = user["dueDate"] as! Double

                            users[self.event.patron.id!] = nil
                            value["users"] = users
                            
                            // update book
                            db?.child(DatabaseInfo.checkedOutListTable).child(book.key).updateChildValues(value)
                            // update user 
                            
                            // comment for testing
                            if let index = self.event.patron.booksCheckedOut.index(of: book.key){
                                
                                self.event.patron.booksCheckedOut.remove(at: index)
                                self.event.patron.numberOfBooksCheckoutToday -= 1
                                
                                db?.child(DatabaseInfo.patronTable).child(self.event.patron.id!).updateChildValues(self.event.patron.dict)
                                
                                AppDelegate.setPatron(self.event.patron)
                            }
 
                            let dueDate = DateHelper.numberFromLocalToday(dt: dueDateTimeInterval)

                            if dueDate <= 0{
                                let fineAmount = (-1 * dueDate) + 1
                                self.returnBooksInfo.append(ReturnBookInfo(nameOfBook: book.title!, fineAmount: fineAmount))
                            }else{
                                self.returnBooksInfo.append(ReturnBookInfo(nameOfBook: book.title!, fineAmount: 0))
                            }
                            
                            // When a book becomes available, the first person on the waiting list is notified about its availability,
                            // and the person is removed from the waiting list.
                            
                            // optional binding
                            if let numberOfCopies = value["numberOfCopies"] as? Int{
                                // room for one more
                                if users.count == numberOfCopies - 1{
                                
                                    DispatchQueue.global().async {
                                
                                        self.notifyNextUserFromWaitList(book: book)
                                        
                                    }
                                    
                                }
                            }
                            
                        }else{
                            
                        }
                        
                        self.doReturn()
                        
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
   
    
}


protocol ReturnBooksDelegate: AbstractEventDelegate {
    
}

enum ReturnBooksState{
    case error
    case success
    case overflow
}
