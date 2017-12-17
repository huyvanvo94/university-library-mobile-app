//
//  BookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class PatronBookViewController: BaseViewController, BookKeeper, AbstractEventDelegate {
 
    
    var patron: Patron?
    var book: Book?
    
    //Outlets
    @IBOutlet weak var bookTitleLabel: GeneralUILabel!
    @IBOutlet weak var bookAuthorLabel: GeneralUILabel!
    @IBOutlet weak var bookPublisherLabel: GeneralUILabel!
    @IBOutlet weak var bookLocationLabel: GeneralUILabel!
    @IBOutlet weak var bookCopiesLabel: GeneralUILabel!
    @IBOutlet weak var bookStatusLabel: GeneralUILabel!
    @IBOutlet weak var coverImage: UIImageView!
    //action
    @IBAction func returnBookAction(_ sender: Any) {
        Logger.log(clzz: "PatronBookViewController", message: "returnBookAction")
        if let book = self.book{
            self.doReturn(books: [book])
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if let patron = AppDelegate.fetchPatron(){
            self.patron = patron
        }else{
            self.patron = Mock.mock_Patron()
        }
        // Do any additional setup after loading the view.
        
        self.loadBookToUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadBookToUI(){
        Logger.log(clzz: "PatronBookVC", message: "loadBookToUI")
        self.title = "Book Details"
   
        
        if let title = self.book?.title{
            bookTitleLabel.text = "Title: " + title
        }
        if let author = self.book?.author{
            bookAuthorLabel.text = "Author: " + author
        }
        if let publisher = self.book?.publisher{
            bookPublisherLabel.text = "Publisher: " + publisher
        }
        if let location = self.book?.locationInLibrary{
            bookLocationLabel.text = "Location: " + location
        }
        if let copies = self.book?.numberOfCopies{
            bookCopiesLabel.text = "# of Copies: " + String(copies)
        }
        
        if let _ = self.book?.base64Image{
            self.coverImage.image = self.book?.image
        }
       
        if let status = self.book?.bookStatus{
            bookStatusLabel.text = "Status: \(status)"
        }
  
    }

    func checkout(book: Book) {
        if let patron = self.patron {
            let checkout = CheckoutList(patron: patron, book: book)
            let event = CheckoutListEvent(checkoutList: checkout)
            event.delegate = self
        }
    }
    
    func waiting(book: Book) {
        
    }
    
    func doReturn(book: Book) {
        if let patron = self.patron {
            let event = ReturnBookEvent(patron: patron, book: book)
            event.delegate = self
        }
    }
    
    func doReturn(books: [Book]) {
        if let patron = self.patron {
            let event = ReturnBooksEvent(patron: patron, books: books)
            event.delegate = self
        }
    }
    
    func search(for: Book) {
        
    }
    
    func search(exact book: Book){
        
        
    }
    
    func complete(event: AbstractEvent){
        switch event{
        case let event as ReturnBooksEvent:
            if event.state == ReturnBooksState.success{
                self.alertMessage(title: "Return Receipt", message: "Return successful", actionTitle: "OK", handler: { (handler) in
                    
                    if let vc = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as? MyCheckoutBooksViewController{
                        vc.fetchBooks()
                         self.popBackView()
                    }
                })
            }
        default:
            print("No Action")
        }
    }
    
    func error(event: AbstractEvent){
        
    }
    
    func fetch(book: Book) {
        
    }
    
    func fetch() {
        
    }
    
    func doRenew(book: Book) {
        
    }

    func checkout(books: [Book]){

    }
}
