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
        
        self.borderStyle = UITextBorderStyle.roundedRect

            self.font = UIFont(name: "Helvetica", size: Screen.height * 0.04)
            self.layer.cornerRadius = 5.0
            self.layer.borderColor = UIColor(red: 55/255, green: 78/255, blue: 95/255, alpha: 1.0).cgColor
            self.layer.borderWidth = 1.0
            self.layer.masksToBounds = true
        
    }
    
}
