//
//  StatusTextField.swift
//  UniversityLibrary
//
//  Created by student on 12/9/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit


class StatusTextField : GeneralUITextField, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate{
    
    let options = ["", "Available", "Not Available", "Processing", "Deactivated", "Unknown"]
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.borderStyle = .none
       
        self.font = UIFont(name: "Verdana", size: Screen.height * 0.02)
   
        self.layer.cornerRadius = 5.0
        self.textColor = UIColor(rgb: 0x000000)
        self.textAlignment = .left
        
        let picker = UIPickerView()
        self.inputView = picker
        picker.delegate = self
        picker.showsSelectionIndicator = true
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(StatusTextField.pickerOnTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        picker.addGestureRecognizer(tap)
        picker.isUserInteractionEnabled = true
        tap.delegate = self
    }
    
    
    //MARK: UIPickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = options[row]
        pickerView.removeFromSuperview()
        
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func pickerOnTap(_ sender: UITapGestureRecognizer){
        
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    func makeEditable(){
        self.borderStyle = .roundedRect
        self.isUserInteractionEnabled = true
        self.layer.borderColor = UIColor(red: 55/255, green: 78/255, blue: 95/255, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
    }
    
    func makeNotEditable(){
        self.borderStyle = .none
        self.isUserInteractionEnabled = false
        
        self.layer.borderWidth = 0

        
    }
}

