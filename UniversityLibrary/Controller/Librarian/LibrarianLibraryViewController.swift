//
//  LibrarianLibraryViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class LibrarianLibraryViewController: BaseViewController, BookKeeper {
    var librarian: Librarian?

    func search(for: Book) {
        
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        super.logout()
    }
    
    @IBAction func goToAddBooksVC(_ sender: MenuUIButton) {
        
        self.goToAddBooksView()
    }
    
    
    func goToAddBooksView(){
        if let vc  = self.storyboard?.instantiateViewController(withIdentifier: "AddBookViewController") as? AddBookViewController{
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func goToSearchBooks(_ sender: MenuUIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.title = "Library"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
  
    
    func checkout(book: Book) {
        
    }
    
    func waiting(book: Book) {
        
    }
    
    func doReturn(book: Book) {
        
    }
    
    func doReturn(books: [Book]) {
        
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
