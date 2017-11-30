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
                
                var list = [ReturnBookInfo]()
              
                var current: Book?
                while self.books.isEmpty == false{
                    
                
                    current = self.books.popLast()
                    self.doReturn(book: current!, completion: {(returnBookInfo) in
                    
                        list.append(returnBookInfo)
                        current = self.books.popLast()
                    })
                    
                }
                
                
                
                DataService.shared.returnConfirmationTransaction(data: ReturnBookInfo.convertToArrayString(books: list), email: self.patron.email!, completion: { (success) in
                    
                    if (success){
                        
                    }else{
                        
                    }
                    
                })
                
                
            
            }
            
        }
    }
    
    func doReturn(book: Book, completion: ((ReturnBookInfo)-> ())?){
        let db = FirebaseManager().reference
        
        db?.child(DatabaseInfo.checkedOutListTable).child(book.key).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if var value = snapshot.value as? [String: Any]{
                if var users = value["users"] as? Dictionary<String, Any>{
                    
                    if users[self.patron.id!] != nil{
                        users[self.patron.id!] = nil
                        value["users"] = users
                        
                        db?.child(DatabaseInfo.checkedOutListTable).child(book.key).updateChildValues(value)
                        
                        if let completion = completion{
                            // test
                            completion(ReturnBookInfo(nameOfBook: "example", fineAmount: -1))
                        }
                        
                    }else{
                        
                    }
                    
                }
            }
            
        })
    }
}


protocol ReturnBooksDelegate: AbstractEventDelegate {
    
}

enum ReturnBooksState{
    case error
    case success
    case overflow
}
