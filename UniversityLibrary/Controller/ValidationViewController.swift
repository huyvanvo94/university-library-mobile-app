//
//  ValidationViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

/*
 * Once user has successfully register, user will be sent to the
 * validation page to input validation code.
 */
class ValidationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove sign up view controller
        self.navigationController?.viewControllers.remove(at: (self.navigationController?.viewControllers.count)! - 2)
        
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
