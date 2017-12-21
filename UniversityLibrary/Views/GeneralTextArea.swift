//
//  GeneralTextArea.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/20/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit

class GeneralTextArea: UITextView{
 
    override func awakeFromNib() {
        self.clipsToBounds = true
        self.textColor = UIColor(rgb: 0x143468)
        self.font = UIFont(name: "Verdana", size: Screen.height * 0.020)
        self.textAlignment = .left
        
        self.layer.borderColor = UIColor(red: 55/255, green: 78/255, blue: 95/255, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
    }
}
