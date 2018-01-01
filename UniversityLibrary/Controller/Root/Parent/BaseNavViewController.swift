//
//  BaseNavViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/18/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class BaseNavViewController: UINavigationController {
    
 
    override func loadView() {
        super.loadView()
        self.navigationBar.barTintColor = UIColor(rgb: 0x4286f4)
        
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
         
        self.navigationBar.titleTextAttributes = textAttributes
        
        self.view.backgroundColor = .white

    }

    override func viewDidLoad() {
        super.viewDidLoad()

 
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
