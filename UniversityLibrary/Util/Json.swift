//
//  Json.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/28/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation


struct CheckoutBookInfo{
    var returnCount = 0
    
    let patron: Patron
    let book: Book
    
    init(patron: Patron, book: Book){
        self.patron = patron
        self.book = book
    }
    var bookInfo:String{
        get{
            return self.book.bookInfo
        }
    }
    
    var email:String{
        get{
            return self.patron.email!
        }
    }
    
    var transactionTime: String{
        get{
            let now = Date()
            
            return DateHelper.getLocalTime(dt: now.timeIntervalSince1970)

        }
    }
    
    var transactionDate: String{
        
        get{
            let now = Date()

            return DateHelper.getLocalDate(dt: now.timeIntervalSince1970)
        }
    }
    
    var dueDate: String{
        get{
            let dueDate = Date().thirtyDaysfromNow
            return DateHelper.getLocalDate(dt: dueDate.timeIntervalSince1970)
        }
    }
    
    var dict: [String: Any]{
        get{
            var user = [String: Any]()
            user["dueDate"] = Date().thirtyDaysfromNow.timeIntervalSince1970
            user["transactionDate"] = Date().thirtyDaysfromNow.timeIntervalSince1970
            user["email"] = self.patron.email!
            user["id"] = self.patron.id!
            
            let transaction = Date().timeIntervalSince1970
            
            user["dueDateInfo"] = dueDate
            
            user["transactionDateInfo"] = transactionDate
            
            user["renewCount"] = self.returnCount
        
            return user
        }
    }
    
}

struct ReturnBookInfo{
    var nameOfBook: String
    var fineAmount: Int
    
    init(nameOfBook: String, fineAmount: Int){
        self.nameOfBook = nameOfBook
        self.fineAmount = fineAmount
        
    }
    
    func convertToJsonString()->String{
        return "{\"nameOfBook\":\"\(self.nameOfBook)\",\"fineAmount\":\"\(self.fineAmount)\" dollars}"
    }
    
    static func convertToArrayString(books: [ReturnBookInfo]) -> String{
        
        if books.count == 0{
            return "none"
        }
        
        if books.count == 1{
            return "[" + books[0].convertToJsonString() + "]"
        }
        
        var msg = "["
        
      
        
        for i in 0..<books.count-1{
            msg += books[i].convertToJsonString() + ","

        }
        
        msg += books[books.count-1].convertToJsonString()+"]"
        
        return msg
    }
}




