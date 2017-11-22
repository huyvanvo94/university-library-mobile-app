//
//  Checkout.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class CheckoutList: UniModel{
    
    let patron: Patron
    let book: Book
    
    var thirdDaysFromNowDueDate: Date {
        get{
            let today = Date()
            return today.thirtyDaysfromNow
        }
    }
    
    func formatDueDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium//Set date style
        
        return dateFormatter.string(from: date)
        
    }
     
    
    init(patron: Patron, book: Book) {
        self.patron = patron
        self.book = book 
    }
    

}
