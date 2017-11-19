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
    init(patron: Patron, book: Book) {
        self.patron = patron
        self.book = book 
    }
}
