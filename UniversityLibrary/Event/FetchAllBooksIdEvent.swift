//
//  FetchAllBooksKey.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/4/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class FetchAllBooksIdEvent: AbstractEvent{
    
    var ids = [String]()
    
    var delegate: AbstractEventDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    
    func async_ProcessEvent() {
        
        guard let delegate = self.delegate else {
            return
        }
        
        let queue = DispatchQueue.global()
        
        queue.async {
            
            let db = FirebaseManager().reference
            
            db?.child(DatabaseInfo.booksAdded).observe(.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in snapshots {
                        
                        if let dict = child.value as? Dictionary<String, Any> {
                          
                            if let id = dict["id"] as? String{
                       //       print(id)
                                self.ids.append(id)
                            }
                        }
                        
                        
                    }
                    
                    delegate.complete(event: self)
                }
            })
            
            
        }
        
    }
}
