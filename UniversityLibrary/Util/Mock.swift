//
//  Mock.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/18/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class Mock{
    
    static let isMockMode = false
    
    static var mockDate = Date()
    
    
    
    static func mock_Patron() -> Patron{ 
        let p = Patron(email: "tes2t@gmail.com", password: "123123", universityId: 123124)
        p.id = "OJ9l7IyjsAVg3ATqkdhsRl0AqJG3"
        p.booksCheckedOut = ["688277688078079"]
        return p
    }
    
    static func mock_Patron2() -> Patron{
        
        let p = Patron(email: "t134t@gmail.com", password: "144023", universityId: 123191)
      
        p.id = "t2cQttDSBiVen5EYRWX0PmQG3Hx2"
        //p.id = "u2cQttDSBiVen5EYRWX0PmQG3Hx2"
        return p
    }
    
    static func mock_Librarian()->Librarian{
        let l = Librarian(email: "test@sjs.edu", password: "123213", universityId: 213213)
    
        l.id = "231xsdfdsfsdf"
        return l 
    }
    
    static func mock_Book2() -> Book!{
        let book = Book.Builder()
            .setTitle("Harry Potter")
            .setAuthor( "JK Rowling")
            .setKeywords( ["wizards", "harr potter", "magic"])
            .setCallNumber("214214124124")
            .setLocationInLibrary("Floor B")
            .setNumberOfCopies( 1)
            .setYearOfPublication( 2001)
            .build()
        
        return book
        
    }
    
    static func mock_Book() -> Book!{
        let book = Book.Builder()
            .setTitle("Test")
            .setAuthor("Test test")
            .setKeywords(["A", "B", "C"])
            .setCallNumber("124214214")
            .setLocationInLibrary("Floor A")
            .setNumberOfCopies( 1)
            .setYearOfPublication( 1923)
            .build()

        book.id = "-L0L3XcwPwUblrQkKV3n"
        
        return book
    
    }
}

