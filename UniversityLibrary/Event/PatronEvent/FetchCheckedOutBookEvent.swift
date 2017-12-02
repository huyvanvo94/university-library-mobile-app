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
            
            self.book = Mock.mock_Book2()
            delegate.complete(event: self)
        }
    }
}

protocol FetchCheckedOutDelegate: AbstractEventDelegate {
    func completeCheckoutFetch(book: Book)
}

