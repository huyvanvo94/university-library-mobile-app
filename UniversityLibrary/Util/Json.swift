//
//  Json.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/28/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

struct ReturnBookInfo{
    var nameOfBook: String
    var fineAmount: Int
    
    init(nameOfBook: String, fineAmount: Int){
        self.nameOfBook = nameOfBook
        self.fineAmount = fineAmount
        
    }
    
    func convertToJsonString()->String{
        return "{\"nameOfBook\":\"\(self.nameOfBook)\",\"fineAmount\":\"\(self.fineAmount)\"}"
    }
    
    static func convertToArrayString(books: [ReturnBookInfo]) -> String{
        
        var msg = "["
        
        for i in 0..<books.count-1{
            msg += books[i].convertToJsonString() + ","

        }
        
        msg += books[books.count-1].convertToJsonString()+"]"
        
        return msg
    }
}




