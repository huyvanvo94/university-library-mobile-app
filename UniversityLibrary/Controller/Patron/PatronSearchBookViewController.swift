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
  
        let event = FetchBookEvent(key: book.key)
        event.delegate = self
      
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
        self.title = "Exact Search"
        
        self.hideKeyboardWhenTappedAround()
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
     
    }

    func complete(event: AbstractEvent){
        super.activityIndicatorView.stopAnimating()
        
        
        switch event {
     
        case let event as FetchBookEvent:
            if let book = event.book{
                self.goToCheckoutBookVC(with: book)
            }
            
 
        default:
            print("No action")
        }
    }

    func error(event: AbstractEvent){
        super.activityIndicatorView.stopAnimating()
        
        if let _ = event as? FetchBookEvent{
            self.alertMessage(title: "Oops", message: "Cannot find book!")
            
            
        }
        
    }
 
    @IBAction func searchForBook(_ sender: UIButton) {
    
        if let book = buildSearchBook(){
            
            super.activityIndicatorView.startAnimating()
            self.fetch(book: book)
            
            self.clearText()
        }else{
            self.clearText()
          
            self.alertMessage(title: "Error", message: "Invalid inputs")
        }
 
    }

    func goToCheckoutBookVC(with book: Book ){
        Logger.log(clzz: "PatronSearchBoookVC", message: "go to checkout view controller")
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutBookViewController") as? CheckoutBookViewController{
            vc.book = book
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    func checkout(books: [Book]){

    }
}
