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
  
    weak var delegate: BookCRUDDelegate?
    
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
                
                
                db?.child(DatabaseInfo.booksAdded).observe(.value, with: {
                    (snapshot) in
                    
                    // if book key exist user must able to add to db
                    if snapshot.hasChild(self.book.key){
                        self.state = .error
                        delegate.error(event: self)
                        // stop listening to db
                        db?.child(DatabaseInfo.booksAdded).removeAllObservers()
                        
                    }else{
                        let db = FirebaseManager().reference
                        
                        let key = db?.child(DatabaseInfo.bookTable).childByAutoId().key
                        
                        
                        db?.child(DatabaseInfo.booksAdded).child(self.book.key).setValue(["id": key])
                        
                        db?.child(DatabaseInfo.bookTable).child(key!).setValue(self.book.dict)
                        
                        
                        self.state = .success
                        delegate.complete(event: self)
                        // stop listening to db 
                        db?.child(DatabaseInfo.booksAdded).removeAllObservers()
                    }
                })
               
            case .delete:
                Logger.log(clzz: "BookEvent", message: "delete")
                
                let db = FirebaseManager().reference
                
                db?.child(DatabaseInfo.booksAdded).observe(.value, with: { (snapshot) in
                    
                    // Firebase contains book
                    // Librarian is able to delete book
                    if snapshot.hasChild(self.book.key){
                        
                        // This observe function is use to fetch _id from table
                        // With this _id, we know what child to delete
                        db?.child(DatabaseInfo.booksAdded).observe(.value, with: {(snapshot) in
                            if let data = snapshot.value as? NSDictionary{
                                if let metaInfo = data[self.book.key] as? Dictionary<String, Any>{
                                    if let id = metaInfo["id"] as? String{
                                        db?.child(DatabaseInfo.bookTable).child(id).removeValue()
                                        // also remove value from reference table
                                        db?.child(DatabaseInfo.booksAdded).child(self.book.key).removeValue()
                                        
                                        self.state = .success
                                        delegate.complete(event: self)
                                    }
                                
                                }
                            }else{
                                
                            }
                            
                            db?.removeAllObservers()
                        })
                    }else{
                        
                    }
                    
                })
                
                
                
            case .update:
                Logger.log(clzz: "BookEvent", message: "update")
                
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
}


enum BookActionState{
    case error
    case success
    
}

protocol BookCRUDDelegate : AbstractEventDelegate{
    
    
}
