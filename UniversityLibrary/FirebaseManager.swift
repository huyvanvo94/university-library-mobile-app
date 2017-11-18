//
//  FirebaseManager.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/14/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager{
    var reference: DatabaseReference!
    
    init(){
        self.reference = Database.database().reference() 
    }
    
}
