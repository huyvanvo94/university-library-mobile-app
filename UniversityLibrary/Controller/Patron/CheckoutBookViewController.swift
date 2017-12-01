//
//  CheckoutBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class CheckoutBookViewController: BaseViewController {

    @IBOutlet weak var bookName: UILabel!
    
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var lastCheckoutDate: UILabel!
    
    @IBOutlet weak var publisherName: UILabel!
   
    
    @IBAction func checkoutButtonOnClick(_ sender: UIButton) {
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign all UIObjects values from the list passed by patronAllBooksViewController
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
