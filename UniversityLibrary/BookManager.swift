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
    func update(with id: Int, book: Book)
    func delete(book: Book)
    
}
