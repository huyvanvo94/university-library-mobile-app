//
//  AddBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class AddBookViewController: BaseViewController {

    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var bookAuthor: UITextField!
    
    
    @IBOutlet weak var bookCallNo: UITextField!
    
    
    @IBOutlet weak var bookPub: UITextField!
    
    @IBOutlet weak var bookPubYear: UITextField!
    @IBOutlet weak var bookKeywords: UITextField!
    @IBOutlet weak var bookStat: UITextField!
    @IBOutlet weak var bookLibLoc: UITextField!
    @IBOutlet weak var bookCopiesNo: UITextField!
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
