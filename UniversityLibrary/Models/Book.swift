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

    // For application logic
    var toggle = false 
    // for mywistinglist view controller 
    var toReturn = false

    // End for application logic

    // For saving to db

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

    var bookStatus: String?

    var lastUpDateBy: String? // ex: john.le@sjs.edu
    
    // if a user checks out this book, this count is increase
    var numberOfBooksCheckedOut: Int = 0
    
    var base64Image: String?
 
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

        if let lastUpDateBy = dict["lastUpDateBy"] as? String{
            self.lastUpDateBy = lastUpDateBy
        }
        
        if let locationInLibrary = dict["locationInLibrary"] as? String{
            self.locationInLibrary = locationInLibrary
        }
        if let bookStatus = dict["bookStatus"] as? String{
            self.bookStatus = bookStatus
        }
        if let base64Image = dict["base64Image"] as? String{
            self.base64Image = base64Image
        }
    }
    
     
    override init() {
        
    }
    
    func initCheckoutList()->[String: Any]{
        var dict = [String: Any]()
        dict["numberOfCopies"] = numberOfCopies
        dict["isEmpty"] = true
        dict["isFull"] = false
        dict["id"] = id
        dict["title"] = title
        return dict
    }
    
    func initWaitingList()-> [String: Any]{
        var dict = [String: Any]()
        dict["numberOfCopies"] = numberOfCopies
        dict["isEmpty"] = true
        dict["isFull"] = false
        dict["id"] = id
        dict["title"] = title
        return dict
    }
     
    var key: String{
        get{
            
         
            var key = ""
            
            if let title = self.title{
                key += title
            }
          
            if let author = self.author{
                key += author
            }
            
            if let yearOfPublication = self.yearOfPublication{
               
                key += String(yearOfPublication)
            }
            
            if let publisher = self.publisher{
                key += String(publisher)
            }
            
            return String(key.hashValue)
        }
    }
    
    override var hashKey: Int{
        get{
            var hashValue = super.hashKey
            
            hashValue = 123131
           
            if let author = self.author{
                
                print(author.hashValue)
            }
            
            if let title = self.title{
             
                print(title.hashValue)
            }

            /*
            if let callNumber = self.callNumber{
                hashValue += callNumber.hashValue
            }
            
            if let publisher = self.publisher{
                hashValue += publisher.hashValue
            }
            
            if let yearOfPublication = self.yearOfPublication{
                hashValue += yearOfPublication.hashValue
            }*/
            
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
            dict["lastUpDateBy"] = lastUpDateBy
            dict["locationInLibrary"] = locationInLibrary
            dict["bookStatus"] = bookStatus
            dict["base64Image"] = base64Image
            return dict
        }
    }


    var bookInfo: String{
        get{
            return "\(title!) by \(author!)"
        }
    }

    class Builder{
        private var book: Book!
        
        init() {
            self.book = Book()
        }
        
        func setId(_ id: String) -> Builder{
            book?.id = id
            return self
        }
        
        func setAuthor(_ author: String) -> Builder{
            book?.author = author
            return self
        }
        
        func setTitle(_ title: String) -> Builder{
            book?.title = title
            return self
        }
        
        func setCallNumber(_ callNumber: String) -> Builder{
            book?.callNumber = callNumber
            return self
            
        }
        
        func setPublisher(_ publisher: String) -> Builder{
            book?.publisher = publisher
            return self
        }
        
        func setYearOfPublication(_ yearOfPublication: Int) -> Builder{
            book?.yearOfPublication = yearOfPublication
            return self
        }
        
        func setLocationInLibrary(_ locationInLibrary: String) -> Builder{
            book?.locationInLibrary = locationInLibrary
            return self
        }
        
        func setNumberOfCopies(_ numberOfCopies: Int) -> Builder{
            book?.numberOfCopies = numberOfCopies
            return self
        }
        
        func setKeywords(_ keywords: [String]) -> Builder{
            book?.keywords = keywords
            return self
        }
        
        func setKeywords(_ keywords: String) -> Builder{
            var keywords = keywords.trimmingCharacters(in: .whitespacesAndNewlines)
            keywords = keywords.replacingOccurrences(of: " ", with: ",", options: .literal, range: nil)
            let arrKeywords = keywords.components(separatedBy: ",")
            book.keywords = arrKeywords
          
            return self 
        }

        func setLastUpDateBy(_ lastUpDateBy: String ) -> Builder{
            book?.lastUpDateBy = lastUpDateBy
            return self
        }

        func setBookStatus(_ bookStatus: String) -> Builder{
            book?.bookStatus = bookStatus
            return self
        }
        
        func setImage(base64: String) -> Builder{
            book?.base64Image = base64
            return self
        }
        
        func setImage(image: UIImage?) -> Builder{
            if let image = image{
                book?.base64Image = book?.base64Str(image: image)
            }
            
            
            return self
        }
        
        func build() -> Book{
            return book
        }
    }

    var updateBook: Book?




    func base64Str(image: UIImage) -> String{
    
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        return imageData.base64EncodedString(options: .lineLength64Characters)
        
    }
    
    func makeImageFrom(base64: String)-> UIImage{
        let dataDecoded : Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)!
        return UIImage(data: dataDecoded)!

    }
    
    var image: UIImage?{
        get{ 
            if let base64Image = self.base64Image{
                return self.makeImageFrom(base64: base64Image)
            }
            
            return nil
        }
    }
 
    func getKey() throws -> String{
        
        var key = ""
        
        if let title = self.title{
            key += title
        }
        
        if let author = self.author{
            key += author
        }
        
        if let yearOfPublication = self.yearOfPublication{
            
            key += String(yearOfPublication)
        }
        
        if let publisher = self.publisher{
            key += String(publisher)
        }
        
        return String(key.hashValue)
        
    }
    
}

enum HashError: Error{
    case one
}
