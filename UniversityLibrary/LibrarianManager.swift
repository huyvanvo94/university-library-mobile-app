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
 
    func search(by book: Book) {
        
    }
    
    func add(with book: Book) {
        Logger.log(clzz: "LibrarianManager", message: "add")
        let event = BookEvent(book: book, action: .add)
        event.delegate = self
        event.async_ProcessEvent()
        
    }
    
    func update(with id: Int, book: Book) {
        
    }
    
    func delete(book: Book) {
        Logger.log(clzz: "LibrarianManger", message: "delete")
        
        let event = BookEvent(book: book, action: .delete)
        event.delegate = self
        event.async_ProcessEvent()
         
    }
    
    func complete(event: AbstractEvent) {
        
    }
    
    func error(event: AbstractEvent) {
        
    }
    
}

protocol BookManager {
    
    func search(by book: Book)
    func add(with book: Book)
    func update(with id: Int, book: Book)
    func delete(book: Book)
}
