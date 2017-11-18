//
//  LibrarianHelper.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class LibrarianHelper: BookManager {
    let user: Librarian
    
    init(user: Librarian) {
        self.user = user
    }
 
    func search(by book: Book) {
        
        
    }
    
    func add(with book: Book) {
        
    }
    
    func update(with id: Int, book: Book) {
        
    }
    
    func delete(book: Book) {
        
        
    }
    
}

protocol BookManager {
    
    func search(by book: Book)
    func add(with book: Book)
    func update(with id: Int, book: Book)
    func delete(book: Book)
}
