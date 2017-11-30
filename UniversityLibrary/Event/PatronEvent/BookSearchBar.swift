//
//  BookSearchBar.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class BookSearchBar: UISearchBar {

    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        searchBarStyle = UISearchBarStyle.prominent
        isTranslucent = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/3)
      
        let font = UIFont(name: "search for book", size: UIFont.buttonFontSize)
        self.init(frame: frame, font: font!, textColor: UIColor.gray)
        
    }

    
    override func awakeFromNib() {
    
    }
}
