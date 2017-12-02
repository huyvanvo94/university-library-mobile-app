//
//  MenuUIButton.swift
//  UniversityLibrary
//
//  Created by student on 12/1/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class MenuUIButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 4
        backgroundColor = UIColor(rgb: 0x5b5bff)
        
        self.setTitleColor(.white, for: .normal)
        
    }
    
    override var isHighlighted: Bool{
        get{
            return super.isHighlighted
        }
        set{
            if newValue{
                //highlight state
                backgroundColor = UIColor(rgb:0x3333FF)
            }else{
                //normal state
                backgroundColor = UIColor(rgb:0x5b5bff)
            }
        }
    }

}
