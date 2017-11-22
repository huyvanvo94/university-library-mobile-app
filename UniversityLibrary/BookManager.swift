//
//  BookManager.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
/*
 * The protocol that a class needs to conform to.
 * This should be used to do firebase operations. 
 */
protocol BookManager: class {
    // CRUD Operations 
    func search(by book: Book)
    func add(with book: Book)
    // once users search for a book, it should return the book class
    // then, users should be able to update book
    // the book in this arguement is the updated version
    // user should NOT be able to update id, title, or author 
    func update(book: Book)

    func delete(book: Book)
    
    func search(exact book: Book)
}
