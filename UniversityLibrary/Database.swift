//
//  Database.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/3/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

protocol Database{
    
    func update(dict: [String: Any], completion: Bool?)
    
    func delete(dict: [String: Any], completion: Bool?)
    
    func remove(dict: [String: Any], completion: Bool?)
    
    func add(dict: [String: Any], completion: Bool?)
    
}

class DBFirebase: Database{
    func update(dict: [String : Any], completion: Bool?) {
        
    }
    
    func delete(dict: [String : Any], completion: Bool?) {
        
    }
    
    func remove(dict: [String : Any], completion: Bool?) {
        
    }
    
    func add(dict: [String : Any], completion: Bool?) {
        
    }
}


