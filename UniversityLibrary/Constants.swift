//
//  Constants.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

let isMock = false

struct DatabaseInfo{
    static let librarianTable = "librarian"
    static let patronTable = "patron"
    
    // Table of the book
    static let bookTable = "book"
    // Table to determine if book has been added
    // This wil help in querying 
    static let booksAdded = "books_added"
    
    // Patrons on the waiting list
    static let waitingListTable = "waiting_list"
    
    // Patrons on the checkout lsit
    static let checkedOutListTable = "checkout_list"
    
    
    static let registerEmailTable = "register_email"
    static let registerUniversityIdTable = "register_university_id"
    
    static let reserveTable = "reserve_books"
}
