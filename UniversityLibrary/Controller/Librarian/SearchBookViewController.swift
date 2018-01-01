//
//  SearchBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class LibrarianSearchBookViewController: BaseViewController, BookManager {
  
    @IBOutlet weak var bookTitle: UITextField!
    
    
    @IBOutlet weak var author: UITextField!
    
    
    @IBOutlet weak var publisher: UITextField!
    
    
    @IBOutlet weak var yearOfPublication: UITextField!
    
    @IBOutlet weak var locationInLibrary: UITextField!
    
    @IBOutlet weak var currentStatus: UITextField!
    
    @IBOutlet weak var callNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func searchBook(_ sender: UIButton) {
        guard let bookTitle = self.bookTitle.text, let author = self.author.text, let publisher = self.publisher.text, let yearOfPublication = self.yearOfPublication.text, let locationInLibrary = self.locationInLibrary.text,  let callNumber = self.callNumber.text else {
            return
        }
        
        let book = Book.Builder()
            .setTitle(title: bookTitle )
            .setAuthor(author: author)
            .setCallNumber(callNumber: callNumber)
            .setLocationInLibrary(locationInLibrary: locationInLibrary)
            .setYearOfPublication(yearOfPublication: Int(yearOfPublication)!)
            .setPublisher(publisher: publisher)
            .build()
        
        self.sea
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
