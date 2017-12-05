//
//  BookKeeper.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

/*
 * This class should be used by view controller to perform patron operations 
 */
 
protocol BookKeeper: class{
    func checkout(book: Book)
    func waiting(book: Book)
    func doReturn(book: Book)
    func doReturn(books: [Book])
    func search(for: Book)
}


 
