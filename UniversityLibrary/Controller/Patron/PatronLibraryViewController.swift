//
//  LibraryViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit
/**
 * Displays all books 
 */
class PatronLibraryViewController: BaseViewController, BookManager {


    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var bookCell: UIView!
    
    
    @IBOutlet weak var nameBookCell: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(by book: Book){
        
    }
    func add(with book: Book){
        
    }
    // once users search for a book, it should return the book class
    // then, users should be able to update book
    // the book in this arguement is the updated version
    // user should NOT be able to update id, title, or author
    func update(book: Book){
        
    }
    
    func delete(book: Book){
        
    }
    
    func search(exact book: Book){
        
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
