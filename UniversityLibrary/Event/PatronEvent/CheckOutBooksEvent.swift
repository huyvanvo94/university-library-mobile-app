//
//  CheckOutBooksEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/4/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

import Foundation
import Firebase

class CheckoutBooksEvent: AbstractEvent{
    var receipt = ""
    
    var isComplete = false
    
    weak var delegate: AbstractEventDelegate? {
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    var books: [Book]
    let patron: Patron
    
    init(books: [Book], patron: Patron){
        self.books = books
        self.patron = patron
    }
   
    func async_ProcessEvent() {
        
        guard let _ = self.delegate else {
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.checkoutbooksevent")
        
        queue.async {
            let helper = CheckoutBooksHelper(event: self)
            helper.doCheckout() 
        }
    }
    
    func checkout(book: Book, patron: Patron, completion: ((CheckoutState) -> () )?){
        let db = FirebaseManager().reference.child(DatabaseInfo.checkedOutListTable)
        
        
        db.child(book.key).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if var value = snapshot.value as? [String: Any]{
                if let numberOfCopies = value["numberOfCopies"] as? Int{
                    
                    if var users = value["users"] as? Dictionary<String, Any>{
                        
                        if users[patron.id!] != nil{
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
                        }else if var reservation = value["reservation"] as? Dictionary<String, Any>{
                             
                        }else{
                            
                            let checkoutInfo = CheckoutBookInfo(patron: patron, book: book)
                     
                            users[patron.id!] = checkoutInfo.dict
                            
                            value["users"] = users
                            db.child(book.key).updateChildValues(value)
                            
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
                                
                                self.receipt += "Book: \(book.title!)  \nDue Date: \(checkoutInfo.dueDate)\n"
                                completion(.success)
                            }
                            
                        }
                    }else{
                        Logger.log(clzz: "CheckoutListEvent", message: "checkout")
                        
                        let checkoutInfo = CheckoutBookInfo(patron: patron, book: book)
                        
                        let user = checkoutInfo.dict
                        
                        value["users"] = [patron.id! : user]
                        
                        db.child(book.key).updateChildValues(value)
                        
                        
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
                            
                            self.receipt += "Book: \(book.title!)  \nDue Date: \(checkoutInfo.dueDate)\n"
                            
                            completion(.success)
                        }
                        
                    }
                    
                }
            }
            
        })
    }
    
    
    class CheckoutBooksHelper{
        
        let event: CheckoutBooksEvent
        
        init(event: CheckoutBooksEvent){
            self.event = event
        }
      
        func doCheckout(){
            if event.books.isEmpty{
                
                self.event.isComplete = true
                
                self.event.delegate?.complete(event: self.event)
                
                return
            }
            
            if let book = event.books.popLast(){
                self.doCheckout(book: book)
            }else{
                
                self.event.delegate?.complete(event: self.event)
            }
            
        }
        
        func doCheckout(book: Book){
            
            
            self.event.checkout(book: book, patron: event.patron, completion: {(state) in
                
                switch state{
                    
                case .success:
                    
                    Logger.log(clzz: "CheckoutListEvent", message: "success")
                    
                    let db = FirebaseManager().reference.child(DatabaseInfo.patronTable)
                    
                    db.child(self.event.patron.id!).observeSingleEvent(of: .value, with: {(snapshot) in
                        
                        
                        if let _ = snapshot.value as? [String: Any]{
                          
                            self.event.patron.booksCheckedOut.append(book.key)
                            self.event.patron.totalNumberOfBooksCheckout += 1
                            self.event.patron.timeStamp()
                            
                            db.child(self.event.patron.id!).updateChildValues(self.event.patron.dict)
                            
                            AppDelegate.setPatron(self.event.patron)
                            self.event.delegate?.complete(event: self.event)
                        }
                        
                    })
                    
                case .contain:
                    
                    Logger.log(clzz: "CheckoutListEvent", message: "contain")
                    self.event.delegate?.complete(event: self.event)
                    
                case .full:
                    self.event.delegate?.complete(event: self.event)
                default:
                    self.event.delegate?.error(event: self.event)
                }
                
                self.doCheckout()
         
            })
        }
       
    }
}


