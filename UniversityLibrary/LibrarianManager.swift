//
//  LibrarianHelper.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation 
/*
 * This class is mainly used to test.
 * Controllers should do CRUD operations
 */
class LibrarianManager: BookManager, BookCRUDDelegate {
    let user: Librarian
    
    init(user: Librarian) {
        self.user = user
    }
 
    func search(exact book: Book) {
        Logger.log(clzz: "LibrarianManager", message: "search exactly")
        let event = BookEvent(book: book, action: .searchExactly)
        event.delegate = self
        
    }
    
    func search(by book: Book) {
       
        
    }
    
    func add(with book: Book) {
        Logger.log(clzz: "LibrarianManager", message: "add")
       
        let event = BookEvent(book: book, action: .add)
        event.delegate = self
    }
    
 
    func update( book: Book) {
        Logger.log(clzz: "LibrarianManager", message: "update")
        
        let event = BookEvent(book: book, action: .update)
        event.delegate = self
    }
    
    func delete(book: Book) {
        Logger.log(clzz: "LibrarianManger", message: "delete")
        
        let event = BookEvent(book: book, action: .delete)
        event.delegate = self
     
    }
    
    func complete(event: AbstractEvent) {
        
 
        
    }
    
    func error(event: AbstractEvent) {
        
    }
    
    func result(exact book: Book){
        print(book.id!)
        
    }
    
}

 
