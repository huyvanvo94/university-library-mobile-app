//
//  PatronSearchBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class PatronSearchBookViewController: BaseViewController, BookKeeper, AbstractEventDelegate {
    var patron: Patron?
    
    func fetch(book: Book) {
        
    }
    
    func fetch() {
        
    }
    
    
    //MARK: Properties
    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var author: UITextField!
    
    @IBOutlet weak var publisher: UITextField!
    
    @IBOutlet weak var yearOfPublication: UITextField!
    
    @IBOutlet weak var locationInLibrary: UITextField!
    @IBOutlet weak var callNumber: UITextField!
    @IBOutlet weak var currentStatus: UITextField!
    
    override func loadView() {
        super.loadView()
        self.title = "Search"
    }
    func clearText(){
        bookTitle.text = ""
        author.text = ""
        publisher.text = ""
        yearOfPublication.text = ""
    }
    
    func buildSearchBook() -> Book?{
        guard let title = bookTitle.text, let author = author.text, let year = Int(yearOfPublication.text!), let publisher = publisher.text else{
         
            return nil
        }
        
        let book = Book.Builder()
            .setAuthor(author)
            .setTitle(title)
            .setPublisher(publisher)
            .setYearOfPublication(year)
            .build()
        
        return book
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let patron = AppDelegate.fetchPatron(){
            self.patron = patron
        }else{
            self.patron = Mock.mock_Patron()
        }
        

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
    
    func search(for: Book) {
        
    }
    
    func doRenew(book: Book) {
        
    }
 
    func search(exact book: Book){
        let event = SearchBookEvent(book: book)
        event.delegate = self
        
    }
    func complete(event: AbstractEvent){
        super.activityIndicatorView.stopAnimating()
        
        if let event = event as? SearchBookEvent{
            if event.state == SearchBookState.success{
                
                self.goToCheckoutBookVC(with: event.book)
            }
        }
        
    }
    func error(event: AbstractEvent){
        super.activityIndicatorView.stopAnimating()
        
        if let _ = event as? SearchBookEvent{
            super.showToast(message: "Can't find book")
            
            
        }
        
    }
 
    @IBAction func searchForBook(_ sender: UIButton) {
        
        if Mock.isMockMode{
            self.goToCheckoutBookVC(with: Mock.mock_Book())
        }else{
            
            if let book = buildSearchBook(){
                
                super.activityIndicatorView.startAnimating()
                self.search(exact: book)
                
                self.clearText()
            }else{
                self.clearText()
                self.showToast(message: "Invalid inputs")
            }
        }
 
        
    }
    
    
   
   

    func goToCheckoutBookVC(with book: Book ){
        //CheckoutBookViewController
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutBookViewController") as? CheckoutBookViewController{
            
           self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
