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

    var eventBook: Book?

    let librarian: Librarian
    let action: BookAction
    let book: Book
    
    var state: BookActionState?
  
    init(librarian: Librarian, book: Book, action: BookAction){
        self.action = action
        self.book = book
        self.librarian = librarian
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
                        self.state = .exist
                        delegate.complete(event: self)
                   
                    }else{
               
                        let db = FirebaseManager().reference

                        // set last add by

                 
                        let email = self.librarian.email
                        self.book.lastUpDateBy = email
 
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
                                                if let checkoutListDict = value as? Dictionary<String, Any>{
                                                    
                                                    if let _ = checkoutListDict["users"] as? Dictionary<String, Any>{
                                                        
                                                        self.state = .checkoutListNotEmpty
                                                        delegate.complete(event: self)
                                                        
                                                    }
                                              
                                                    else{
                                                        
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
                        print(value)
                        print(self.book.key)
                        if let metaInfo = value[self.book.key] as? Dictionary<String, Any>{
                            if let id = metaInfo["id"] as? String{
                                print(id)
                                db?.child(DatabaseInfo.bookTable).child(id).observeSingleEvent(of: .value, with: {(snapshot) in
                                    if let value = snapshot.value as? NSDictionary{
                                        
                                        if let bookDict = value as? Dictionary<String, Any>{
 
                                            let book = Book(dict: bookDict)
                                            book.lastUpDateBy = self.librarian.email
                                         
                                            self.state = .success
                                            self.eventBook = book  
                                            delegate.complete(event: self)
                                           
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

                    if let updatedBook = self.book.updateBook{

                        let email = self.librarian.email!

                        updatedBook.lastUpDateBy = email

                        db?.child(DatabaseInfo.bookTable).child(self.book.id!).updateChildValues(updatedBook.dict)


                        // update child

                        // change waiting table
                        // change books added
                        // change checkout list
                        db?.child(DatabaseInfo.waitingListTable).child(self.book.key).observeSingleEvent(of: .value, with: {(snapshot) in
                            if let value = snapshot.value as? Dictionary<String, Any>{

                                db?.child(DatabaseInfo.waitingListTable).child(self.book.key).removeValue()
                                db?.child(DatabaseInfo.waitingListTable).child(updatedBook.key).updateChildValues(value)
                            }
                            
                            db?.child(DatabaseInfo.booksAdded).child(self.book.key).observeSingleEvent(of: .value, with: {(snapshot) in
                                if let value = snapshot.value as? Dictionary<String, Any>{

                                    db?.child(DatabaseInfo.booksAdded).child(self.book.key).removeValue()
                                    db?.child(DatabaseInfo.booksAdded).child(updatedBook.key).updateChildValues(value)
                                    
                                }
                                
                                db?.child(DatabaseInfo.checkedOutListTable).observeSingleEvent(of: .value, with: {(snapshot) in
                                    if let value = snapshot.value as? Dictionary<String, Any>{

                                        do{
                                            let newValue = value[self.book.key] as! Dictionary<String, Any>
                                            db?.child(DatabaseInfo.checkedOutListTable).child(self.book.key).removeValue()
                                            db?.child(DatabaseInfo.checkedOutListTable).child(updatedBook.key).updateChildValues(newValue)
                                        }catch let err{
                                            print(err)
                                        }
                                        


                                        



                                    }
                                    
                                    self.state = .success
                                    delegate.complete(event: self)
                                })
                            })
                            
                            
                        })

  
                    }

                    self.state = .error
                    delegate.error(event: self)

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
    
    case exist
    case notExist
    
    case waitingListNotEmpty
    
    case checkoutListNotEmpty
    
    case deleteSuccess
    case updateSuccess
}

protocol BookCRUDDelegate : AbstractEventDelegate{
 
    
}
