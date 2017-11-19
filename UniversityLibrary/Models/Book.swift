//
//  Book.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class Book: UniModel{
    var author: String?
    var title: String?
    var callNumber: String?
    var publisher: String?
    var yearOfPublication:Int?
    var locationInLibrary: String?
    var numberOfCopies: Int?
    var isCheckoutByPatron: Bool = false 
    var keywords: [String]?
    
    init(snapShot: DataSnapshot){
        
    }
    
    override init() {
        
    }
    
    // key used for firebase
    var key: String{
        get{
            return author! + title! + String(yearOfPublication!)
        }
    }
    
    
    var dict: [String: Any]{
        get{
            return ["author": author ?? nil,
                    "title": title ?? nil,
                    "callNumber": callNumber ?? nil,
                    "publisher": publisher ?? nil,
                    "yearOfPublication": yearOfPublication ?? nil,
                    "numberOfCopies": numberOfCopies ?? nil,
                    "isCheckoutByPatron": isCheckoutByPatron,
                    "keywords": keywords ?? nil]
        }
    }
    
    // We will use the builder design pattern to build the Book class easier
    class Builder{
        private var book: Book!
        
        init() {
            self.book = Book()
        }
        
        func setAuthor(author: String) -> Builder{
            book?.author = author
            return self
        }
        
        func setTitle(title: String) -> Builder{
            book?.title = title
            return self
        }
        
        func setCallNumber(callNumber: String) -> Builder{
            book?.callNumber = callNumber
            return self
            
        }
        
        func setPublisher(publisher: String) -> Builder{
            book?.publisher = publisher
            return self
        }
        
        func setYearOfPublication(yearOfPublication: Int) -> Builder{
            book?.yearOfPublication = yearOfPublication
            return self
        }
        
        func setLocationInLibrary(locationInLibrary: String) -> Builder{
            book?.locationInLibrary = locationInLibrary
            return self
        }
        
        func setNumberOfCopies(numberOfCopies: Int) -> Builder{
            book?.numberOfCopies = numberOfCopies
            return self
        }
        
        func setKeywords(keywords: [String]) -> Builder{
            book?.keywords = keywords
            return self
        }
        
        func build() -> Book{
            return book
        }
    }
    
}
