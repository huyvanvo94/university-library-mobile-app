//
//  UModel.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class UniModel: NSObject{
    var id: String?
    
    var hashKey: Int{
        get{
            return 0
        }
    }
    
    var dict: [String: Any]{
        var dict = [String: Any]()
        dict["id"] = id
        return dict
    }
    
}
