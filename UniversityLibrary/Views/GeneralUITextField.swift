//
//  GeneralUITextField.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

// Mark General 
class GeneralUITextField: UITextField {


    override func awakeFromNib() {
        
         self.font = UIFont(name: "Helvetica", size: Screen.height * 0.04)
    }
}
