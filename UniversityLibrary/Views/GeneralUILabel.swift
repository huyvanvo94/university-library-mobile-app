//
//  GeneralUILabel.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit


class GeneralUILabel: UILabel {
 
    override func drawText(in rect: CGRect) {
 
      
        super.drawText(in: rect)
    }
    
    override func awakeFromNib() {

        self.clipsToBounds = true
        self.textColor = UIColor(rgb: 0x143468)
        self.font = UIFont(name: "Verdana", size: Screen.height * 0.020)
        self.textAlignment = .left
   
    }
}
