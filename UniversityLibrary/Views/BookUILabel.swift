//
//  BookUILabel.swift
//  UniversityLibrary
//
//  Created by student on 12/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit

class BookUILabel: GeneralUILabel{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Verdana", size: Screen.height * 0.02)
        self.heightAnchor.constraint(equalToConstant: Screen.height * 0.025).isActive = true
    }
    
    
}
