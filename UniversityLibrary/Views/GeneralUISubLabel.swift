//
//  GeneralUISubLabel.swift
//  UniversityLibrary
//
//  Created by student on 12/4/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit


class GeneralUISubLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
    }
    
    override func awakeFromNib() {
        
        self.clipsToBounds = true
        self.textColor = UIColor(rgb: 0x8c8c8c)
        self.font = UIFont(name: "Verdana", size: Screen.height * 0.020)
        self.textAlignment = .left
        
    }
}

