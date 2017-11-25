//
//  BookEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/18/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class BookEvent: AbstractEvent{
  
    weak var delegate: BookCRUDDelegate? {
        didSet{
            self.async_ProcessEvent() 
        }
    }
    
    let action: BookAction
    let book: Book
    
    var state: BookActionState?
  
    init(book: Book, action: BookAction){
        self.action = action
        self.book = book 
    }
    

    func async_ProcessEvent() {
        guard let delegate = self.delegate else {
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.event.bookevent")
        
        queue.async {
            
            switch self.action{
            case .add:
                Logger.log(clzz: "BookEvent", message: "add")
                
                let db = FirebaseManager().reference 
                db?.child(DatabaseInfo.booksAdded).observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    
                    // I cannot add because database already has a book with same author and title
                    if snapshot.hasChild(self.book.key){
                        self.state = .error
                        delegate.error(event: self)
                   
                    }else{
                        let db = FirebaseManager().reference
                        
                        let id = db?.child(DatabaseInfo.bookTable).childByAutoId().key
                        
                        // The books added so far table currently contains book id for quick reference
                        db?.child(DatabaseInfo.booksAdded).child(self.book.key).setValue(["id": id])
                        
                        // Insert child book into book table 
                        self.book.id = id
                        db?.child(DatabaseInfo.bookTable).child(id!).setValue(self.book.dict)
                       
                        // init waiting list table with empty users and number of copies 
                        db?.child(DatabaseInfo.waitingListTable).child(self.book.key)
                            .setValue(self.book.initWaitingList())
                        // init checkout list table with empy users and number of copies
                        db?.child(DatabaseInfo.checkedOutListTable).child(self.book.key)
                            .setValue(self.book.initCheckoutList())
                        
                        self.state = .success
                        delegate.complete(event: self)
                    }
                })
               
            case .delete:
                Logger.log(clzz: "BookEvent", message: "delete")
                
                let db = FirebaseManager().reference
                
                db?.child(DatabaseInfo.booksAdded).observeSingleEvent(of: .value, with: {(snapshot) in
                    
                    // Firebase contains book
                    // Librarian is able to delete book
                    if snapshot.hasChild(self.book.key){
                        
                        // This observe function is use to fetch _id from table
                        // With this _id, we know what child to delete
                        // TODO: Check if book is on waiting list 
                        db?.child(DatabaseInfo.booksAdded).observeSingleEvent(of: .value, with: {(snapshot) in
                            if let data = snapshot.value as? NSDictionary{
                                if let metaInfo = data[self.book.key] as? Dictionary<String, Any>{
                                    if let id = metaInfo["id"] as? String{
                                          db?.child(DatabaseInfo.checkedOutListTable).child(self.book.key).observeSingleEvent(of: .value, with: {(snapshot) in
                                            
                                            if let value = snapshot.value as? NSDictionary{
                                                if let waitingListDict = value as? Dictionary<String, Any>{
                                                    
                                                    if let isEmpty = waitingListDict["isEmpty"] as? Bool{
                                                        if isEmpty == false{
                                                            
                                                            self.state = .waitingListNotEmpty
                                                            delegate.complete(event: self)
                                                        }else{
                                                            db?.child(DatabaseInfo.bookTable).child(id).removeValue()
                                                            // also remove value from reference table
                                                            db?.child(DatabaseInfo.booksAdded).child(self.book.key).removeValue()
                                                            db?.child(DatabaseInfo.waitingListTable).child(self.book.key).removeValue()
                                                            db?.child(DatabaseInfo.checkedOutListTable).child(self.book.key).removeValue()
                                                            
                                                            self.state = .success
                                                            delegate.complete(event: self)
                                                        }
                                                    }
                                                    
                                                    
                                                }
                                            }
                                            
                                       
                                        })
                                        
                               
                                    }
                                
                                }
                            }else{
                                
                            }
                            
                        })
                    }else{
                        
                    }
                    
                })
            case .searchExactly:
                Logger.log(clzz: "BookEvent", message: "search exactly")
                
                let db = FirebaseManager().reference
                
                db?.child(DatabaseInfo.booksAdded).observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? NSDictionary{
                        if let metaInfo = value[self.book.key] as? Dictionary<String, Any>{
                            if let id = metaInfo["id"] as? String{
                                db?.child(DatabaseInfo.bookTable).child(id).observeSingleEvent(of: .value, with: {(snapshot) in
                                    if let value = snapshot.value as? NSDictionary{
                                        
                                        if let bookDict = value as? Dictionary<String, Any>{
                                            
                                            let book = Book(dict: bookDict)
                                            delegate.result(exact: book)
                                        }
                                        
                                    }
                                })
                                
                            }
                        }
                    }else{
                        
                        
                    }
                })
                
            
            
            case .update:
                
                // current will add to DB if value does not exists 
                Logger.log(clzz: "BookEvent", message: "update")
                
                let db = FirebaseManager().reference
                
                // currently i am updating with book ID
                db?.child(DatabaseInfo.bookTable).child(self.book.id!).observeSingleEvent(of: .value, with: {(snapshot) in
                    // only update the book table
                    db?.child(DatabaseInfo.bookTable).child(self.book.id!).updateChildValues(self.book.dict)
                    
                
                    // perhaps update waiting table key and checkout list
                    
                    db?.child(DatabaseInfo.waitingListTable).child(self.book.key).updateChildValues(["numberOfCopies": self.book.numberOfCopies])
                    db?.child(DatabaseInfo.checkedOutListTable).child(self.book.key).updateChildValues(["numberOfCopies": self.book.numberOfCopies])
                    
                })
          
                
            default:
                Logger.log(clzz: "BookEvent", message: "search")
            }
        }
        
    }
    
   
    
}

enum BookAction{
    case add
    case delete
    case update
    case search
    
    case searchExactly
}


enum BookActionState{
    case error
    case success
    
    case notExist
    
    case waitingListNotEmpty
}

protocol BookCRUDDelegate : AbstractEventDelegate{
   // func result(like book: Book)
    func result(exact book: Book)
    
}
