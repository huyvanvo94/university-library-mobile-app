//
//  BookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class LibrarianBookViewController: BaseViewController, BookManager, BookCRUDDelegate {

    var librarian: Librarian?
    var book: Book?
 
    //Outlets
    @IBOutlet weak var bookTitleTextField: CustomUITextField!
    @IBOutlet weak var bookAuthorTextField: CustomUITextField!
    @IBOutlet weak var bookPublisherTextField: CustomUITextField!
    @IBOutlet weak var bookLocationTextField: CustomUITextField!
    @IBOutlet weak var bookCopiesTextField: CustomUITextField!
    @IBOutlet weak var bookStatusTextField: CustomUITextField!
    
    override func loadView() {
        super.loadView()
        
     
        self.navigationController?.isToolbarHidden = false
      
        self.loadBookToView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editBookAction(_ sender: UIBarButtonItem) {
        
        if Mock.isMockMode{
            return
        }
        if let book = self.book{
            self.update(book: book)
        }
    }

    
    @IBAction func deleteBookAction(_ sender: UIBarButtonItem) {
    
        if Mock.isMockMode {
            return
        }
        if let book = self.book{
            super.activityIndicatorView.startAnimating()
            self.delete(book: book)
        }
    
    }
    
    // MARK: Kevin
    func loadBookToView(){
        self.title = "Book Details"
        // then load book to view 
        if let book = self.book{
            if let title = book.title{
                bookTitleTextField.text = "Title: " + title
            }
            if let author = book.author{
                bookAuthorTextField.text = "Author: " + author
            }
            if let publisher = book.publisher{
                bookPublisherTextField.text = "Publisher: " + publisher
            }
            if let location = book.locationInLibrary{
                bookLocationTextField.text = "Location: " + location
            }
            if let copies = self.book?.numberOfCopies{
                bookCopiesTextField.text = "# of Copies: " + String(copies)
            }
            let status = book.canCheckout
            
            if !status{
                bookStatusTextField.text = "Status: Not Available"
            }else{
                bookStatusTextField.text = "Status: Available"
            }
            
        }
    }
    
    // MARK: -Kevin
    // allow text view to be edit about
    func disableTextViewInput(){
        bookTitleTextField.makeNotEditable()
        bookAuthorTextField.makeNotEditable()
        bookPublisherTextField.makeNotEditable()
        bookLocationTextField.makeNotEditable()
        bookCopiesTextField.makeNotEditable()
        bookStatusTextField.makeNotEditable()
    }
    
    // MARK: -Kevin
    
    func enableTextViewInput(){
        bookTitleTextField.makeEditable()
        bookTitleTextField.makeEditable()
        bookAuthorTextField.makeEditable()
        bookPublisherTextField.makeEditable()
        bookLocationTextField.makeEditable()
        bookCopiesTextField.makeEditable()
        bookStatusTextField.makeEditable()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func search(exact book: Book) {
    
    }
    
    func search(by book: Book) {
        
        
    }
    
    func add(with book: Book) {
       
    }
    
    
    func update(book: Book) {
        if let librarian = self.librarian {
            let event = BookEvent(librarian: librarian, book: book, action: .update)
            event.delegate = self
        }
    }
    
    func delete(book: Book) {

        if let librarian =  self.librarian {
            let event = BookEvent(librarian:librarian, book: book, action: .delete)
            event.delegate = self
        }
  
    }
    
    func complete(event: AbstractEvent) {
        self.activityIndicatorView.stopAnimating()
       
        if let event = event as? BookEvent{
           
            if event.action == .update{
                
                self.displayAnimateSuccess()
                
            }else if event.action == .delete{
                 if event.state == BookActionState.success{
                    self.popBackView()
                 }else if event.state == BookActionState.checkoutListNotEmpty{
                    
                    super.showToast(message: "Is Checkout!")
                }
                    
                    
            }
        }
        
    }
    
    func error(event: AbstractEvent) {
        
    }
    
    func result(exact book: Book){
        
     
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
