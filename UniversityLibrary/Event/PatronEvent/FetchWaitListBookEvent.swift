//
//  FetchWaitListBookEvent.swift
//  UniversityLibrary
//
//  Created by student on 12/2/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class FetchWaitListBookEvent: AbstractEvent {
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

protocol FetchWaitListDelegate: AbstractEventDelegate {
    func completeWaitListFetch(book: Book)
}
