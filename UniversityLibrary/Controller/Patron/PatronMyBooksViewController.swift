//
//  PatronMyBooksViewController.swift
//  UniversityLibrary
//
//  Created by Nayan Goel on 12/1/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class PatronMyBooksViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cellClicked = -1
    
    //make a list of book details for all books
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
         //return total number of rows to be displayed
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
        
        let tableCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "allBooksCell")
        
        tableCell.textLabel?.text = "Book Title" //instead of "Book Title", use allbooksList[indexPath.row]
        
        return tableCell
        
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
        
        cellClicked = indexPath.row
        performSegue(withIdentifier: "bookDetailsSegue", sender: self)
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
