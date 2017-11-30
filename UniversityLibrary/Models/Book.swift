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
    // author is required as it is used for key
    var author: String?
    
    // title is required as it is used for key
    var title: String?
    var callNumber: String?
    var publisher: String?
    var yearOfPublication:Int?
    var locationInLibrary: String?
    var numberOfCopies: Int = 0
    var isCheckoutByPatron: Bool = false 
    var keywords: [String]?
    
    // if a user checks out this book, this count is increase
    var numberOfBooksCheckedOut: Int = 0
 
    var canCheckout: Bool {
        get{
            if self.numberOfBooksCheckedOut == self.numberOfCopies{
                return false
            }else{
                self.numberOfBooksCheckedOut += 1
                return true
            }
            
        }
      
    }
    
    
    init(dict: [String: Any]){
        super.init()
     
        if let author = dict["author"] as? String{
            self.author = author
        }
        if let title = dict["title"] as? String{
            self.title = title
        }
        if let callNumber = dict["callNumber"] as? String{
            self.callNumber = callNumber
        }
        if let publisher = dict["publisher"] as? String{
            self.publisher = publisher
        }
        if let yearOfPublication = dict["yearOfPublication"] as? Int{
            self.yearOfPublication = yearOfPublication
        }
        
        if let numberOfCopies = dict["numberOfCopies"] as? Int{
            self.numberOfCopies = numberOfCopies
        }
  
        if let isCheckoutByPatron = dict["isCheckoutByPatron"] as? Bool{
            self.isCheckoutByPatron = isCheckoutByPatron
        }
        
        if let keywords = dict["keywords"] as? Array<String>{
            self.keywords = keywords
        }
        
        if let id = dict["id"] as? String{ 
            self.id = id
        }
    }
    
     
    override init() {
        
    }
    
    //TODO: Check dependency
    func initCheckoutList()->[String: Any]{
        var dict = [String: Any]()
        dict["numberOfCopies"] = numberOfCopies
        dict["isEmpty"] = true
        dict["isFull"] = false 
        return dict
    }
    
    //TODO: Check dependency
    func initWaitingList()-> [String: Any]{
        var dict = [String: Any]()
        dict["numberOfCopies"] = numberOfCopies
        dict["isEmpty"] = true
        dict["isFull"] = false
        return dict
    }
    
    // key used for firebase
    var key: String{
        get{
            return author! + title!
        }
    }
    
    override var hashKey: Int{
        get{
            var hashValue = super.hashKey
           
            if let _ = self.author{
                hashValue += author!.hashValue
            }
            
            if let _ = self.title{
                hashValue += self.title!.hashValue
            }
            
            if let _ = self.callNumber{
                hashValue += self.callNumber!.hashValue
            }
            
            if let _ = self.publisher{
                hashValue += self.publisher!.hashValue
            }
            
            if let _ = self.yearOfPublication{
                hashValue += self.yearOfPublication!.hashValue
            }
            
            return hashValue
        }
    }
    
    override var dict: [String: Any]{
        get{
            var dict = super.dict
          
            dict["author"] = author
            dict["title"] = title
            dict["callNumber"] = callNumber
            dict["publisher"] = publisher
            dict["yearOfPublication"] = yearOfPublication
            dict["numberOfCopies"] = numberOfCopies
            dict["isCheckoutByPatron"] = isCheckoutByPatron
            dict["keywords"] = keywords
            dict["numberOfBooksCheckedOut"] = numberOfBooksCheckedOut
            
            return dict
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
