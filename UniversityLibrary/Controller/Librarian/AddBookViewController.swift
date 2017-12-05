//
//  AddBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

/*
 Kevin, be sure to validate inputs
 Make sure each fields are there
 */


class AddBookViewController: BaseViewController, BookCRUDDelegate, BookManager{
 
    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var publisher: UITextField!
    @IBOutlet weak var yearOfPublication: UITextField!
    @IBOutlet weak var locationInLibrary: UITextField!
    @IBOutlet weak var numberOfCopies: UITextField!
    @IBOutlet weak var callNumber: UITextField!
    
    lazy var addBookItemBar: UIBarButtonItem = {
        let image =  UIImage(named: "addBooksIcon.png")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(AddBookViewController.addBookAction(_:)))
        
        self.navigationItem.rightBarButtonItem = button
        
        
        return button
    }()
    
    // Mark: -Kevin
    func clearAllTextFromTextField(){
        
    }
    
    func addBookAction(_ sender: Any){
        
        self.add(with: Mock.mock_Book())
        
        
    }

    
    override func loadView() {
        super.loadView()
        self.title = "Add Book"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBookItemBar.isEnabled = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addBook() {
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
        super.activityIndicatorView.stopAnimating()
        
        switch event {
        case let event as BookEvent:
            if event.state == .success{
               
                super.displayAnimateSuccess()
            }else if event.state == .exist{
                
              /*  self.view.makeToast("Already contains book", point: Screen.center, title: "Error", image: UIImage(named: "error.png"), completion: nil)
            */
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
