//
//  BlueSquareButton.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/29/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class BlueSquareButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 4
        backgroundColor = UIColor(rgb: 0x3333FF)
        
        self.setTitleColor(.white, for: .normal)
       
    }
    
    
}
