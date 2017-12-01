//
//  AddBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class AddBookViewController: BaseViewController, BookCRUDDelegate, BookManager{
 
    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var publisher: UITextField!
    @IBOutlet weak var yearOfPublication: UITextField!
    @IBOutlet weak var locationInLibrary: UITextField!
    @IBOutlet weak var numberOfCopies: UITextField!
    
    @IBOutlet weak var callNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addBook(_ sender: UIButton) {
        guard let bookTitle = self.bookTitle.text, let author = self.author.text, let publisher = self.publisher.text, let yearOfPublication = self.yearOfPublication.text, let locationInLibrary = self.locationInLibrary.text, let numberOfCopies = self.numberOfCopies.text, let callNumber = self.callNumber.text else {
            return
        }
        
        let book = Book.Builder()
            .setTitle(title: bookTitle )
            .setAuthor(author: author)
            .setCallNumber(callNumber: callNumber)
            .setLocationInLibrary(locationInLibrary: locationInLibrary)
            .setNumberOfCopies(numberOfCopies: Int(numberOfCopies)!)
            .setYearOfPublication(yearOfPublication: Int(yearOfPublication)!)
            .setPublisher(publisher: publisher)
            .build()
        
        self.add(with: book)
        
        
    }
    
    func complete(event: AbstractEvent) {
       
        switch event {
        case let event as BookEvent:
            if event.state == .success{
                super.activityIndicatorView.stopAnimating()
                super.showToast(message: "success")
            }
        default:
            print("No action")
        }
        
    }
    
    func error(event: AbstractEvent) {
        
    }
    
    func result(exact book: Book) {
        
    }
    

    // CRUD Operations
    func search(by book: Book){
        
    }
    
    func add(with book: Book){
        
        super.activityIndicatorView.startAnimating()
        
        let event = BookEvent(book: book, action: .add)
        event.delegate = self
        
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
