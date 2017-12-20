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
    }
}
