//
//  Extensions.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit
/*
 * This file should contain extension code to motify existing class
 */

extension UIViewController{
   
    func getSize(image: UIImage) -> Bool{
        let data = UIImagePNGRepresentation(image)!
        
        return (Double(data.count)/(1024*1024)) <= 8.5
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func displayAnimateSuccess(){
        
        // toast presented with multiple options and with a completion closure
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        
        // let center = CGPoint(x: w/2, y: h/2)
        
        let image = UIImage(named: "success.png")
        let imageView = UIImageView(image: image)
        
        imageView.frame.origin.x = w/2 - 10
        imageView.frame.origin.y = h/2
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = false
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
            imageView.alpha = 0.0
        }) { (finished: Bool) in
            imageView.removeFromSuperview()
        }
    }
    
    
    func displayAnimateError(){
        
        // toast presented with multiple options and with a completion closure
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        
        // let center = CGPoint(x: w/2, y: h/2)
        
        let image = UIImage(named: "error.png")
        let imageView = UIImageView(image: image)
        
        imageView.frame.origin.x = w/2 - 10
        imageView.frame.origin.y = h/2
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = false
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
            imageView.alpha = 0.0
        }) { (finished: Bool) in
            imageView.removeFromSuperview()
        }
    }
  
}

private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    /*
     * This IBInspectable adds maxLength property to the UIBuilder
     * This property is used to set studentId maxLength to 6 
     */
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength(textField:)), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text, prospectiveText.characters.count > maxLength else {
            return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
    
 
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension String{
    
    var number: Int?{
        
        return Int( self )
    }
 
    func isValidEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isSJSUEmail() -> Bool{
        return self.isValidEmail() && self.hasSuffix("@sjsu.edu")
    }
    
    var myHash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
}

extension Int{
    var myHash: Int {
      
        let value = "\(self)"
        let unicodeScalars = value.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
}

extension UIScrollView {
    func hideIndicators() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
}





