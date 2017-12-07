//
//  SearchBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class LibrarianSearchBookViewController: BaseViewController, BookManager, BookCRUDDelegate {

    var librarian: Librarian?

    @IBOutlet weak var bookTitle: UITextField!

    @IBOutlet weak var author: UITextField!
    
    
    @IBOutlet weak var publisher: UITextField!
    
    
    @IBOutlet weak var yearOfPublication: UITextField!
    
    @IBOutlet weak var locationInLibrary: UITextField!
    
    @IBOutlet weak var currentStatus: UITextField!
    
    @IBOutlet weak var callNumber: UITextField!
    
    override func loadView() {
        super.loadView()
        self.title = "Search"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        if Mock.isMockMode{
            self.goToBookView(with: Mock.mock_Book())
        }else{
            
            self.doSearchBook()
            
        }
    }
    
    
    func doSearchBook() {
     
        guard let bookTitle = self.bookTitle.text, let author = self.author.text, let publisher = self.publisher.text, let yearOfPublication = Int(self.yearOfPublication.text!) else {
            self.displayAnimateError()
            return
        }
        
        let book = Book.Builder()
            .setTitle(bookTitle )
            .setAuthor(author)
            .setYearOfPublication(yearOfPublication)
            .setPublisher(publisher)
            .build()
        
        self.librarian = Mock.mock_Librarian()
        
        self.search(exact: book)
   
    }
    
    
    
    func search(exact book: Book) {

        if let librarian = self.librarian {
            let event = BookEvent(librarian: librarian, book: book, action: .searchExactly)
            event.delegate = self
        }
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
        
        if let event = event as? BookEvent{
            switch event.action{
             
            case BookAction.searchExactly:
                if event.state == .success{
                    if let book = event.eventBook{
                        self.goToBookView(with: book)
                    }
                }
                
            default:
                print("No action")
            }
            
            
            
            
        }
        
        
    }
    
    func error(event: AbstractEvent) {
        
    }
    
    func result(exact book: Book){
       
   
  
    }
   
    
    
    func goToBookView(with book: Book){
        
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
