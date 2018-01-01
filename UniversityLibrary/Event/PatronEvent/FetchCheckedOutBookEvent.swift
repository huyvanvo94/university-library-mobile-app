//
//  FetchCheckedOutBookEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/1/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation


class FetchCheckedOutEvent: AbstractEvent{
    let patron: Patron
    
    var books = [Book]()
    
    var book: Book?
   
    init(patron: Patron){
        self.patron = patron
    }
    
    weak var delegate: AbstractEventDelegate? {
        didSet{
            self.async_ProcessEvent()
        }
    }
    
  
    func async_ProcessEvent() {
        guard let delegate = self.delegate else {
            return
        }
        
        let queue = DispatchQueue(label: "com.huy.vo.cmpe277.fetchbookevent")
        
        queue.async {
            
            /*
            self.book = Mock.mock_Book2()
            delegate.complete(event: self)*/
            
            let helper = FetchCheckBooksHelper(event: self)
            helper.fetch()
        }
    }
    
    class FetchCheckBooksHelper{
        
        let event: FetchCheckedOutEvent
        
        init(event: FetchCheckedOutEvent){
            self.event = event
        }
        
        func fetch(){
            
            if event.patron.booksCheckedOut.isEmpty{
                event.delegate?.complete(event: event)
                return
            }
            
            let key = event.patron.booksCheckedOut.popLast()!
            
            fetchBook(key: key)
            
        }
    
        func fetchBook(key: String){
            
            let db = FirebaseManager().reference
            
            db?.child(key).observe(.value, with: {(snapshot) in
                
                if let value = snapshot.value as? [String: Any]{
                   
                   
                    let book = Book(dict: value)
                
                    self.event.books.append(book)
                    
                }
                
            })
        }
        
    }
}

protocol FetchCheckedOutDelegate: AbstractEventDelegate {
    func completeCheckoutFetch(book: Book)
}

