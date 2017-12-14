//
//  TestCase.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/6/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation


final class TestCase{
    
    static func testSearchByPatron(){
        
        
        let p = PatronManager(patorn: Mock.mock_Patron())
        let book = Book
            .Builder()
            .setId("-L-eoWKW-RoNJ7G9ro4I")
            .setTitle("test1")
            .setPublisher("test1")
            .setYearOfPublication(2000)
            .setAuthor("test1")
            .build()
        
        
        
        p.search(exact: book)
    }

    static func testCheckoutByPatron(){


        let patron = Mock.mock_Patron()

        patron.email = "huy_vo80@yahoo.com"
        let p = PatronManager(patorn: patron)


        let book = Book
                .Builder()
                .setId("-L-eoWKW-RoNJ7G9ro4I")
                .setTitle("test1")
                .setPublisher("test1")
                .setYearOfPublication(2000)
                .setAuthor("test1")
                .build()


        p.checkout(book: book)
        

    }

    static func testUpdateByLibrarian(){
        let l = LibrarianManager(user: Mock.mock_Librarian())




    }
}
