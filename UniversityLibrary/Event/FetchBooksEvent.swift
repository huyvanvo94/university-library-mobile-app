//
//  FetchBooksEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/4/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class FetchBooksEvent: AbstractEvent{
    var book: Book?
    
    var delegate: AbstractEventDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }
 
    func requestNext(){
       
      
        
    }
    func async_ProcessEvent() {
        
        guard let delegate = self.delegate else{
            
            
            return
        }
        
        DispatchQueue.main.async {
            
            let db = FirebaseManager().reference
            
            db?.child(DatabaseInfo.bookTable).observeSingleEvent(of: .value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in snapshots {
                        
                        if let bookDict = child.value as? Dictionary<String, Any> {
                            
                            let book = Book(dict: bookDict)
                            
                            self.book = book
                            
                            delegate.complete(event: self)
                        }
                        
                        
                    }
                    
                }
            })
        }
    }
}

protocol FetchBooksDelegate: AbstractEventDelegate {
    func complete(book: Book)
}


