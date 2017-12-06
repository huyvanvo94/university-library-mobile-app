//
//  CustomImageView.swift
//  UniversityLibrary
//
//  Created by student on 12/5/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit

class CustomImageView : UIImageView{
    
    override func awakeFromNib() {
        //set image size restraints
        self.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.heightAnchor.constraint(equalToConstant: 200).isActive = true
        //self.image = UIImageView();
      
        
        self.layer.cornerRadius = 0.5
        self.clipsToBounds = true
        self.isUserInteractionEnabled = false
        
    
    }
    
}
