//
//  User.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/14/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class User: Codable{
    var email: String?
    var password: String?
    var universityID: Int?
    
    
}

class Librarian: User{
    
}

class Patron: User{
    
}
