//
// Created by Huy Vo on 12/6/17.
// Copyright (c) 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class SearchBookEvent: AbstractEvent{

    var state: SearchBookState?
    var foundBook: Book?
    
    let book: Book

    init(book: Book){
        self.book = book
    }

    var delegate: AbstractEventDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }
    func async_ProcessEvent() {
        Logger.log(clzz: "SearchBookEvent", message: "process event")
        guard let delegate = self.delegate else{

            return
        }

        let queue = DispatchQueue(label: "com.huy.vo.searchevent")
        queue.async{
            
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
                                        
                                        Logger.log(clzz: "SearchBookEvent", message: "found book: \(book.id!)")
                                      
                                        self.state = .success
                                        self.foundBook = book
                                        delegate.complete(event: self) 
                                    }
                                }
                            })
                            
                        }
                    }
                }else{
                    
                    self.state = .error
                    delegate.error(event: self)
                    
                    
                }
            })





        }




    }
}

enum SearchBookState{
    case success
    case error
}
