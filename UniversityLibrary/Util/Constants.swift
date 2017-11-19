//
//  Constants.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

struct DatabaseInfo{
    static let librarianTable = "librarian"
    static let patronTable = "user"
    
    // Table of the book
    static let bookTable = "book"
    // Table to determine if book has been added
    // This wil help in querying 
    static let booksAdded = "books_added"
    
    //
    static let waitingListTable = "waiting_list"
    
    
    
    static let registerEmailTable = "register_email"
    static let registerUniversityIdTable = "register_university_id"
    
}
