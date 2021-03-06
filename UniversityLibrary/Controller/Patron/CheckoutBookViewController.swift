//
//  CheckoutBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class CheckoutBookViewController: BaseViewController, BookKeeper, AbstractEventDelegate {
    func fetch(book: Book) {
        
    }
    
    func fetch() {
        
    }
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let patron = AppDelegate.fetchPatron(){
            self.patron = patron
        }else{
            self.patron = Mock.mock_Patron()
        }
    
        self.activityIndicatorView.stopAnimating()
       
       
        self.loadBookToUI()
        // Do any additional setup after loading the view.
    }
    
 
    func loadBookToUI(){
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
            bookLocationLabel.text = "Current Location: " + location
        }
        if let copies = self.book?.numberOfCopies{
            bookCopiesLabel.text = "# of Copies: " + String(copies)
        }

        if let status = self.book?.bookStatus{
            bookStatusLabel.text = "Status: \(status)";
        }
        if let _ = self.book?.base64Image{
            coverImage.image = self.book?.image
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Actions
    @IBAction func checkoutAction(_ sender: MenuUIButton) {
        self.checkout(book: book!)
 
    }


    func checkout(book: Book) {
        Logger.log(clzz: "CheckoutVC", message: "checkout")

        if let patron = self.patron {
            let checkout = CheckoutList(patron: patron, book: book)
            let event = CheckoutListEvent(checkoutList: checkout)
            event.delegate = self
        }
    }

    func waiting(book: Book) {
        
        if let patron = self.patron{
            self.activityIndicatorView.startAnimating()
            let waitlist = WaitingList(book: book, patron: patron)
            let event = WaitingListEvent(waitingList: waitlist)
            event.delegate = self
        }

    }

    func doReturn(book: Book) {
        

    }

    func doReturn(books: [Book]) {
       
        if let patron = self.patron{
            let event = ReturnBooksEvent(patron: patron, books: books)
            event.delegate = self
        
        }
    }

    func search(for: Book) {

    }
    
    func doRenew(book: Book) {
        
    }

    func search(exact book: Book){
        
        
    }
    func complete(event: AbstractEvent){

        Logger.log(clzz: "CheckoutbookView", message: "complete")
        self.activityIndicatorView.stopAnimating()
 
        switch event {
        case let event as FetchBookEvent:
            
            if let book = event.book{
                self.book = book
                self.loadBookToUI()
            }
            
        case let event as CheckoutListEvent:
            if event.state == CheckoutState.success{
                
                let info = event.transactionInfo
                
                let infoString = "\(event.checkoutList.book.title!) due on \(info!.dueDate)"
                
                super.alertMessage(title: "Receipt", message: infoString, actionTitle: "OK", handler: {(alert) in
                    
                    self.popBackView()
                })
                
            }else if event.state == .contain{
                self.alertMessage(title: "Error", message: "Already checked out!")
                
            }else if event.state == .full{
                // show add to wait list
                let alert = UIAlertController(title: "Wait List", message: "Would you like to be added to wait list?",  preferredStyle: .actionSheet)
                
                let yes = UIAlertAction(title: "Yes", style: .destructive, handler: {(handler) in
                    let book = event.checkoutList.book
                    self.waiting(book: book)
                    
                })
                let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(yes)
                alert.addAction(no)
                present(alert, animated: true, completion: nil)
                
            }else if event.state == .alreadyOnReserve{
                
                self.alertMessage(title: "Error", message: "On Reserve!")
            }
      
        case let event as WaitingListEvent:
            
            Logger.log(clzz: "CheckoutBookVC", message: "waitlist")
            
            if event.state == .success{
             
                self.alertMessage(title: "Success", message: "Added to wait list success!", handler: {handler in
                    
                    self.popBackView()
                })
            }else if event.state == .duplicate{
                self.alertMessage(title: "Hey", message: "Already on wait list")
            }else{
                self.alertMessage(title: "Oops", message: "Error")
            }
     
        default:
            print("No action")
        }
    }
    func error(event: AbstractEvent){
     
  
        super.activityIndicatorView.stopAnimating()
        
        switch event {
        case let event as CheckoutListEvent:
              self.alertMessage(title: "Oops", message: "You can't check out any more books")
        case let event as WaitingListEvent:
            self.alertMessage(title: "Oops", message: "Cannot be added to waiting list")
        default:
            self.alertMessage(title: "Oops", message: "Someting went wrong.")
        }
    
       


    }

    func checkout(books: [Book]){

    }
    
    

    

}
