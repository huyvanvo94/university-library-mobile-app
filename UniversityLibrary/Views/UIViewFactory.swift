//
//  UIViewFactory.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/29/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit
/*
 * Class to build UI
 */

final class UIViewFactory{
    
}

struct Screen{
    
    static var height: CGFloat{
        get{
            return UIScreen.main.bounds.height
        }
    }
    
    static var width: CGFloat{
        get{
            return UIScreen.main.bounds.width
        }
    }
    
    static var center: CGPoint{
        get{
            let w = UIScreen.main.bounds.width
            let h = UIScreen.main.bounds.height
            
            return CGPoint(x: w/2, y: h/2)
            
        }
    }
}
