//
//  User.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/14/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class User: Codable{
    var email: String!
    var password: String!
    var universityId: Int!
    
    var id: String?
    
    // The user needs to use that verification code to complete his account registration.
    // A registered user cannot really use features in the app until his account is verified.
    var isValidated: Bool = false
    
    init(email: String, password: String, universityId: Int) {
        self.email = email
        self.password = password
        self.universityId = universityId
        
    }
    
    var emailKey: String{
        get{
            return self.email.replacingOccurrences(of: ".", with: "+", options: .literal, range: nil)
        }
    }
    
    var dictEmail: [String: String]{
        get{
            return ["email": email]
        }
    }
    
    var dictUniId:[String: Int]{
        get{
            return ["universityId": universityId]
        }
        
    }
    
    var dict:[String: Any] {
        get{
            return ["id": id, "email": email, "password": password, "universityId": universityId, "isValidated":isValidated]
        }
    }
    
}

class Librarian: User{
    
}

class Patron: User{
    
    // A patron must be able to check out up to 3 books in any day.
    
    func numberOfBookCheckedOut(on date: Date) -> Int{
        
        return -1 
    }
}
