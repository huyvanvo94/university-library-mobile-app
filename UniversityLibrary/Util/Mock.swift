//
//  Mock.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/18/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class Mock{
    
    static func mock_Patron() -> Patron{
 
        let p = Patron(email: "tes2t@gmail.com", password: "123123", universityId: 123124)
        p.id = "xdd2dsfdfsdfssfdsf"
        return p
    }
    
    static func mock_Patron2() -> Patron{
        
        let p = Patron(email: "t134t@gmail.com", password: "144023", universityId: 123191)
        p.id = "131432123"
        return p
    }
    
    static func mock_Librarian()->Librarian{
        let l = Librarian(email: "test@sjs.edu", password: "123213", universityId: 213213)
    
        l.id = "231xsdfdsfsdf"
        return l 
    }
    
    static func mock_Book2() -> Book!{
        let book = Book.Builder()
            .setTitle(title: "Harry Potter")
            .setAuthor(author: "JK Rowling")
            .setKeywords(keywords: ["wizards", "harr potter", "magic"])
            .setCallNumber(callNumber: "214214124124")
            .setLocationInLibrary(locationInLibrary: "Floor B")
            .setNumberOfCopies(numberOfCopies: 1)
            .setYearOfPublication(yearOfPublication: 2001)
            .build()
        
        return book
        
    }
    
    static func mock_Book() -> Book!{
        let book = Book.Builder()
            .setTitle(title: "Test")
            .setAuthor(author: "Test test")
            .setKeywords(keywords: ["A", "B", "C"])
            .setCallNumber(callNumber: "124214214")
            .setLocationInLibrary(locationInLibrary: "Floor A")
            .setNumberOfCopies(numberOfCopies: 11)
            .setYearOfPublication(yearOfPublication: 1923)
            .build()
        
        return book
    
    }
}

