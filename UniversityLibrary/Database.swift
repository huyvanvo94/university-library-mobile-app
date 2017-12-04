//
//  Database.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/3/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

// You must provide a completion function to let other class know the result
protocol UDatabase{
    
    func update(dict: [String: Any], completion: ((Bool) -> ())?)
    
    func delete( dict: [String: Any], completion: ((Bool) -> ())?)
    
    func remove(dict: [String: Any], completion: ((Bool) -> ())?)
    
    func add( dict: [String: Any], completion: ((Bool) -> ())?)
    
}

class DBFirebase: UDatabase{
 
    
    let child: String
    
    init(child: String){
        self.child = child
    }
    // use firebase here
    func update(dict: [String : Any], completion: ((Bool) -> ())?) {
        
    }
    
    func delete(dict: [String : Any], completion: ((Bool) -> ())?) {
        
    }
    
    func remove(dict: [String : Any], completion: ((Bool) -> ())?) {
        
    }
    
    func add(dict: [String : Any], completion: ((Bool) -> ())?) {
        
    }

}


