//
//  PatronManager.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class PatronManager: BookKeeper, AbstractEventDelegate{
    
    func fetch(book: Book) {
        
    }
    
    func fetch() {
        
    }
    
    
    let patorn: Patron
    init(patorn: Patron ){
        self.patorn = patorn
    }
    
    func doReturn(book: Book){
        let event = ReturnBookEvent(patron: self.patorn, book: book)
        event.delegate = self 
        
    }
    
    func doReturn(books: [Book]){
   
        let event = ReturnBooksEvent(patron: self.patorn, books: books)
        event.delegate = self
        
    }
    
    func checkout(book: Book) {
        
        let checkout = CheckoutList(patron: self.patorn, book: book)
        let event = CheckoutListEvent(checkoutList: checkout)
        event.delegate = self
    }
    
    func waiting(book: Book) {
        let waitingList = WaitingList(book: book, patron: self.patorn)
        
        let event = WaitingListEvent(waitingList: waitingList, action: .add)
        event.delegate = self
 
    }
    
    
    
    func complete(event: AbstractEvent) {
        switch event {
        case let event as CheckoutListEvent:
            if event.state == .full{
                
                let book = event.checkoutList.book
                self.waiting(book: book)
            }
            
        default:
            print("No action")
        }
    }
    
    
    func search(for: Book){
        
    }
    
    func error(event: AbstractEvent) {
        
    }
}

