//
//  FetchBookEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/4/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class FetchBookEvent: AbstractEvent{
    
    var book: Book?
    let key: String
    
    var delegate: AbstractEventDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }
    init(key: String){
        self.key = key
        
    }
  
    
    func async_ProcessEvent() {
        
        guard let delegate = self.delegate else {
            return
        }
        
        let queue = DispatchQueue.global()
        
        queue.async {
            
            
            let db = FirebaseManager().reference
            db?.child(DatabaseInfo.booksAdded).child( self.key).observe(.value, with: {(snapshot) in
                
                
                if let value = snapshot.value as? [String: Any]{
                    
                    if let id = value["id"] as? String{
                        
                        db?.child(DatabaseInfo.bookTable).child(id).observe(.value, with: {(snapshot) in
                            
                            if let value = snapshot.value as? [String: Any]{
                                let book = Book(dict: value)
                                print(1)
                                print(book.author)
                                self.book = book
                                delegate.complete(event: self)
                            }
              
                        })
                    }
                    
                    
                }
            })
        }
        
    }
    
}
