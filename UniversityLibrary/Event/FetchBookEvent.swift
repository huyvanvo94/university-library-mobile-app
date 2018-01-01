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
    var key: String?
    var id: String?
    var delegate: AbstractEventDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    init(id: String){
        
        self.id = id
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
            
            
            if let key = self.key{
                Logger.log(clzz: "FetchBookEvent", message: "fetch by key")
                let db = FirebaseManager().reference
                db?.child(DatabaseInfo.booksAdded).child(key).observe(.value, with: {(snapshot) in
                    
                    
                    if let value = snapshot.value as? [String: Any]{
                        
                        if let id = value["id"] as? String{
                            
                            db?.child(DatabaseInfo.bookTable).child(id).observe(.value, with: {(snapshot) in
                                
                                if let value = snapshot.value as? [String: Any]{

                                    queue.sync {
                                        let book = Book(dict: value)

                                        self.book = book
                                        delegate.complete(event: self)
                                    }
                                }else{
                                    delegate.error(event: self)
                                }
                                
                            })
                        }else{
                            delegate.error(event: self)
                        }
                        
                        
                    }else{
                        
                        delegate.error(event: self)
                        
                    }
                })
            }else if let id = self.id{
                Logger.log(clzz: "FetchBookEvent", message: "fetch by id")
                let db = FirebaseManager().reference
                db?.child(DatabaseInfo.bookTable).child(id).observe(.value, with: {(snapshot) in
                    
                    if let value = snapshot.value as? [String: Any]{

                        queue.sync {
                            let book = Book(dict: value)
                            self.book = book

                            delegate.complete(event: self)
                        }
                    }else{
                        delegate.error(event: self)
                    }
                })
            }else{
                delegate.error(event: self)
            }
        }
        
    }
}
