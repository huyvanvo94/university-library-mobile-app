//
//  SearchBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class LibrarianSearchBookViewController: BaseViewController, BookManager, BookCRUDDelegate {
  
    @IBOutlet weak var bookTitle: UITextField!
    
    
    @IBOutlet weak var author: UITextField!
    
    
    @IBOutlet weak var publisher: UITextField!
    
    
    @IBOutlet weak var yearOfPublication: UITextField!
    
    @IBOutlet weak var locationInLibrary: UITextField!
    
    @IBOutlet weak var currentStatus: UITextField!
    
    @IBOutlet weak var callNumber: UITextField!
    
    override func loadView() {
        super.loadView()
        self.title = "Search for exact book"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
 
    
    @IBAction func searchBook(_ sender: UIButton) {
        /*
        if let bookVC = self.storyboard?.instantiateViewController(withIdentifier: "LibrarianBookViewController") as? LibrarianBookViewController{
             
            self.navigationController?.pushViewController(bookVC, animated: true)
        }*/
        /*
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
        
        
        self.search(exact: book)*/
    }
    
    func search(exact book: Book) {
      
        let event = BookEvent(book: book, action: .searchExactly)
        event.delegate = self
        
    }
    
    func search(by book: Book) {
        
        
    }
    
    func add(with book: Book) {
        
    }
    
    
    func update( book: Book) {
 
    }
    
    func delete(book: Book) {
    
    }
    
    func complete(event: AbstractEvent) {
        
        
        
    }
    
    func error(event: AbstractEvent) {
        
    }
    
    func result(exact book: Book){
       
        if let bookVC = self.storyboard?.instantiateViewController(withIdentifier: "LibrarianBookViewController") as? LibrarianBookViewController{
            
            bookVC.book = book
            self.navigationController?.pushViewController(bookVC, animated: true)
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
