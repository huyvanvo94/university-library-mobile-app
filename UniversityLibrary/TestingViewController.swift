//
//  TestingViewController.swift
//  UniversityLibrary
//
//  Created by student on 12/9/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class TestingViewController: UIViewController {
    
    @IBOutlet weak var switchLabel: GeneralUILabel!
    @IBOutlet weak var testingSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
   

    override func viewDidLoad() {
        super.viewDidLoad()
 datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        if !Mock.isMockMode{
            self.testingSwitch.isOn = false
            self.switchLabel.text = "Testing Mode: Off"
        }else{
            self.testingSwitch.isOn = true
            
            self.switchLabel.text = "Testing Mode: On"
        }
        
  //      self.sender.isOn = false
        // Do any additional setup after loading the view.
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
     
    }
    


    func dateChanged(_ sender: UIDatePicker){
        
        if self.testingSwitch.isOn{
        
            Mock.mockDate = sender.date
        
            let date = DateHelper.getLocalDate(dt: Mock.mockDate.timeIntervalSince1970)
        
            print(date)
        
            print(DateHelper.getLocalTime(dt: Mock.mockDate.timeIntervalSince1970))
        }
        
        
    }
    
    @IBAction func toggleMode(_ sender: UISwitch) {
        if sender.isOn{
            switchLabel.text = "Testing Mode: On"
            
        }else{
            switchLabel.text = "Testing Mode: Off"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
