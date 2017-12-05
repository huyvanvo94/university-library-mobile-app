//
//  WaitingList.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

// This class models the waiting class
class WaitingList: UniModel{
    
    let patron: Patron
    let book: Book
    
    
    
    init(book: Book, patron: Patron){
        self.book = book
        self.patron = patron
    }
    
}
