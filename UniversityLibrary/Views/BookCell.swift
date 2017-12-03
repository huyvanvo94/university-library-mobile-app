//
//  BookCell.swift
//  UniversityLibrary
//
//  Created by student on 12/1/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var BookView: UIView!{
        didSet{
            configureView()
        }
    }
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: View Methods
    func configureView(){
        BookView.layer.shadowColor = UIColor.lightGray.cgColor
        BookView.layer.shadowOffset = CGSize(width: 0, height: 10)
        BookView.layer.shadowOpacity = 0.09
        BookView.layer.shadowRadius = 20
        BookView.layer.cornerRadius = 6
        
   
    }
    
 
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            let newWidth = UIScreen.main.bounds.width
            
            let space = (frame.width - newWidth) / 2
            frame.size.width = newWidth
            frame.origin.x += space
            
            super.frame = frame
        }
    }

}
