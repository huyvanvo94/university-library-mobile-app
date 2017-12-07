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

    var editOn = false
    //Outlets
    @IBOutlet weak var bookTitleTextField: CustomUITextField!
    @IBOutlet weak var bookAuthorTextField: CustomUITextField!
    @IBOutlet weak var bookPublisherTextField: CustomUITextField!
    @IBOutlet weak var bookLocationTextField: CustomUITextField!
    @IBOutlet weak var bookCopiesTextField: CustomUITextField!
    @IBOutlet weak var bookStatusTextField: CustomUITextField!
    
    override func loadView() {
        super.loadView()


        self.disableTextViewInput()
     
        self.navigationController?.isToolbarHidden = false
      
        self.loadBookToView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editBookAction(_ sender: UIBarButtonItem) {

        Logger.log(clzz: "LibrariranVC", message: "edit action")
        if !editOn{
            self.enableTextViewInput()
            editOn = true
            return
        }
        
        if Mock.isMockMode{
            self.buildUpdatedBook()

            self.librarian = Mock.mock_Librarian()

            self.update(book: book!)

        }
        else if let book = self.book{
            if self.librarian == nil{
                self.librarian = Mock.mock_Librarian()
            }

            self.buildUpdatedBook()
            self.update(book: book)
        }


    }

    func buildUpdatedBook(){

        let newBook = Book(dict: self.book!.dict)
 
        
        if let title = bookTitleTextField.text {
            newBook.title = title
        }
        if let author = bookAuthorTextField.text{
            newBook.author = author
        }
        if let publisher =  bookPublisherTextField.text{
            newBook.publisher = publisher
        }
        if let location = bookLocationTextField.text {
            newBook.locationInLibrary = location
        }
        if let copies = self.bookCopiesTextField.text{

        }

        self.book?.updateBook = newBook
    }

    
    @IBAction func deleteBookAction(_ sender: UIBarButtonItem) {
    
        if Mock.isMockMode {
            self.librarian = Mock.mock_Librarian()

            self.delete(book: book!)

        }
        if let book = self.book{
            super.activityIndicatorView.startAnimating()
            
            if self.librarian == nil{
                self.librarian = Mock.mock_Librarian()
            }
            
            
            self.delete(book: book)
        }
    
    }
    
    // MARK: Kevin
    func loadBookToView(){
        self.title = "Book Details"
        // then load book to view 
        if let book = self.book{
            if let title = book.title{
                bookTitleTextField.text = title
            }
            if let author = book.author{
                bookAuthorTextField.text =  author
            }
            if let publisher = book.publisher{
                bookPublisherTextField.text = publisher
            }
            if let location = book.locationInLibrary{
                bookLocationTextField.text = location
            }
            if let copies = self.book?.numberOfCopies{
                bookCopiesTextField.text = String(copies)
            }

            if let status = self.book?.bookStatus{
                bookStatusTextField.text = status
            }
         
          

            
        }
    }

    // allow text view to be edit about
    func disableTextViewInput(){
        bookTitleTextField.makeNotEditable()
        bookAuthorTextField.makeNotEditable()
        bookPublisherTextField.makeNotEditable()
        bookLocationTextField.makeNotEditable()
        bookCopiesTextField.makeNotEditable()
        bookStatusTextField.makeNotEditable()
    }

    
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
        Logger.log(clzz: "LibrarianBookViewController", message: "uppdate")
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

                self.book = event.book.updateBook

                self.editOn = false
                self.disableTextViewInput()
                self.displayAnimateSuccess()
                
            }else if event.action == .delete{
                 if event.state == BookActionState.success{
                    print("YO!")
                    
                   self.navigationController?.popToRootViewController(animated: true)
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
