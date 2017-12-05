//
//  CustomUITextField.swift
//  UniversityLibrary
//
//  Created by student on 12/4/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit

//for LibrarianBookView
class CustomUITextField: UITextField {
    
    
    override func awakeFromNib() {
        
        self.borderStyle = UITextBorderStyle.none
        self.font = UIFont(name: "Helvetica", size: Screen.height * 0.04)
        self.layer.cornerRadius = 5.0
        self.textColor = UIColor(rgb: 0x143468)
        self.textAlignment = .left
        self.isUserInteractionEnabled = false
        
    }
    
    func makeEditable(){
        self.borderStyle = UITextBorderStyle.roundedRect
        self.isUserInteractionEnabled = true;
        self.layer.borderWidth = 1.0
    }
    
    func makeNotEditable(){
        self.borderStyle = UITextBorderStyle.none
        self.isUserInteractionEnabled = false
    }
}
