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
        backgroundColor = UIColor(rgb: 0x95b7ed)
        
        self.setTitleColor(.white, for: .normal)
         
        self.frame.size.width = Screen.width * 0.05
        self.frame.size.height = Screen.height * 0.05
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
                backgroundColor = UIColor(rgb:0x95b7ed)
            }
        }
    }

}
