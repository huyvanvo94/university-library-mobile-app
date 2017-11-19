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
    var universityId: Int?
    
    var id: String?
  
    // for sign in
    convenience init(email: String, password: String){
        self.init(email: email, password: password, universityId: nil)
    }
    
    // for sign out
    init(email: String, password: String, universityId: Int?) {
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
    
    var dictUniId:[String: Int?]{
        get{
            return ["universityId": universityId]
        }
        
    }
    
    var dict:[String: Any] {
        get{
            return ["id": id, "email": email, "password": password, "universityId": universityId]
        }
    }
    
}

class Librarian: User{
    
}

class Patron: User{
     
    //The total number of books a patron can keep at any given time cannot exceed 9.
    static let MAX_BOOKS = 9
    var booksChecked = [Book]()
    
    
    // A patron must be able to check out up to 3 books in any day.
    func numberOfBookCheckedOut(on date: Date) -> Int{
        
        return -1 
    }
}
