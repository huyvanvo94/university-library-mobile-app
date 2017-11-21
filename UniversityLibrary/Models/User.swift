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
    
    init(dict: [String: Any]){
        if let email = dict["email"] as? String{
            self.email = email
        }
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
    
    // key
    var dict:[String: Any] {
        get{
            return ["id": id, "email": email, "password": password, "universityId": universityId]
        }
    }
    
}

class Librarian: User{
    
}

class Patron: User{
    
    
    
    let today = Date()
    var numberOfBooksCheckoutToday = 0
    var totalNumberOfBooksCheckout = 0
     
    //The total number of books a patron can keep at any given time cannot exceed 9.
    static let MAX_BOOKS = 9
    //var booksChecked = [Book]()
    
    override init(dict: [String: Any]){
        super.init(dict: dict)

        if let totalNumberOfBooksCheckout = dict["totalNumberOfBooksCheckout"] as? Int{
            self.totalNumberOfBooksCheckout = totalNumberOfBooksCheckout
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func canCheckoutBook() -> Bool{
        if numberOfBooksCheckoutToday < 3{
            numberOfBooksCheckoutToday += 1 
            return true
        }else{
            return false
        }
        
    }
 
    override var dict: [String : Any]{
        get{
            var pDict = super.dict
            
            pDict["totalNumberOfBooksCheckout"] = 0
            return pDict
        }
    }
    
    // A patron must be able to check out up to 3 books in any day.
    func numberOfBookCheckedOut(on date: Date) -> Int{
        
        return -1 
    }
}
