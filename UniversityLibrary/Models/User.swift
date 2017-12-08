//
//  User.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/14/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//
import Foundation

class User: UniModel{
    var email: String!
    var password: String!
    var universityId: Int?
    
    
    // for sign in
    convenience init(email: String, password: String){
        self.init(email: email, password: password, universityId: nil)
    }
    
    static func signOut(){
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "email")
        defaults.set(nil, forKey: "password")
    }
    
    func save(){
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(password, forKey: "password")
    }
    
    static func loadUser(){}
    
    static func fetch() -> User?{
        let defaults = UserDefaults.standard
      
        if let email = defaults.string(forKey: "email"), let password = defaults.string(forKey: "password"){
            return User(email: email, password: password)
        }else{
            return nil
        }
    }
    
    init(dict: [String: Any]){
        super.init()
        
        if let email = dict["email"] as? String{
            self.email = email
        }
        if let id = dict["id"] as? String{
            
            self.id = id
        }
        
        if let password = dict["password"] as? String{
            self.password = password
        }
        if let universityId = dict["universityId"] as? Int{
            self.universityId = universityId
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
    
    // used for firebase 
    override var dict:[String: Any] {
        get{
            var dict = super.dict
             
            dict["email"] = email
            dict["password"] = password
            dict["universityId"] = universityId
            
            return dict
        }
    }
    
}

class Librarian: User{
    
}

class Patron: User{
    
    var lastCheckout: Double?
    let today = Date()
    var numberOfBooksCheckoutToday = 0
    var totalNumberOfBooksCheckout = 0
    // contains id to books
    var booksCheckedOut = [String]()
    // contains id to books
    var booksOnWaitingList = [String]()
     
    //The total number of books a patron can keep at any given time cannot exceed 9.
    static let MAX_BOOKS = 9
    //var booksChecked = [Book]()
    
    func timeStamp(){
        self.lastCheckout = Date().timeIntervalSince1970
        
    }
    
    
    override init(email: String, password: String, universityId: Int?) {

        super.init(email: email, password: email, universityId: universityId)
    }
    
    
    convenience init(email: String, password: String) {
       
        self.init(email: email, password: password, universityId: nil)
    }
    
   
    override init(dict: [String: Any]){
        super.init(dict: dict)

        if let totalNumberOfBooksCheckout = dict["totalNumberOfBooksCheckout"] as? Int{
            self.totalNumberOfBooksCheckout = totalNumberOfBooksCheckout
        }
        
        if let transaction = dict["transaction"] as? Double{
            self.transaction = transaction
        }
        
        if let booksCheckedOut = dict["booksCheckedOut"] as? [String]{
            self.booksCheckedOut = booksCheckedOut
        }
        
        if let booksOnWaitingList = dict["booksOnWaitingList"] as? [String]{
            self.booksOnWaitingList = booksOnWaitingList
        }
        
        if let lastCheckout = dict["lastCheckout"] as? Double{
            self.lastCheckout = lastCheckout
        }
        
        if let numberOfBooksCheckoutToday = dict["numberOfBooksCheckoutToday"] as? Int{
            
            if DateHelper.isToday(dt: self.lastCheckout!){
                self.numberOfBooksCheckoutToday = numberOfBooksCheckoutToday
            }else{
                self.numberOfBooksCheckoutToday = 0
            }
            
            
            print("numberOfBooksCheckout: \(self.numberOfBooksCheckoutToday)")
        }
        
        
    }
    
    /*
    required init(from decoder: Decoder) throws {
      
    }*/
    
    var checkoutDict: [String: Any]{
        get{
            var user = [String: Any]()
            user["dueDate"] = Date().thirtyDaysfromNow.timeIntervalSince1970
            user["email"] = email
            user["id"] = id
            
            return user
        }
    }
    
  
    
    var canCheckoutBook: Bool{
        get{
            if self.booksCheckedOut.count >= 9{
               
                return false
            }
            if numberOfBooksCheckoutToday < 4{
                return true
            }else{
                return false
            }
        }
    }
 
    override var dict: [String : Any]{
        get{
            var pDict = super.dict
           
            pDict["lastCheckout"] = self.lastCheckout
            pDict["numberOfBooksCheckoutToday"] = self.numberOfBooksCheckoutToday
            pDict["totalNumberOfBooksCheckout"] = self.totalNumberOfBooksCheckout
            pDict["transaction"] = self.transaction
            pDict["booksCheckedOut"] = self.booksCheckedOut
            pDict["booksOnWaitingList"] = self.booksOnWaitingList
            return pDict
        }
    }

    var totalNumberOfBooksCheckoutDict: [String: Any]{
        get{
            return ["totalNumberOfBooksCheckout": self.totalNumberOfBooksCheckout]
        }
    }


    var transaction: Double?
    
    // A patron must be able to check out up to 3 books in any day.
    func numberOfBookCheckedOut(on date: Date) -> Int{
        
        return -1 
    }
}
