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


class AddBookViewController: BaseViewController, BookCRUDDelegate, BookManager, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate{

    var librarian: Librarian?
    // outlets
 
    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var publisher: UITextField!
    @IBOutlet weak var yearOfPublication: UITextField!
    @IBOutlet weak var locationInLibrary: UITextField!
    @IBOutlet weak var numberOfCopies: UITextField!
    @IBOutlet weak var callNumber: UITextField!
    
    @IBOutlet weak var currentStatus: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var keywords: GeneralUITextField!
    
    // end outlets
    
    func hideKeyboard(){
        bookTitle.resignFirstResponder()
        publisher.resignFirstResponder()
        yearOfPublication.resignFirstResponder()
        locationInLibrary.resignFirstResponder()
        numberOfCopies.resignFirstResponder()
        callNumber.resignFirstResponder()
        currentStatus.resignFirstResponder()
        keywords.resignFirstResponder()
        
    }
    
    
    
    func fetchImage(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            //   imagePicker.modalPresentationStyle = .popover
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //cover image tap
    func initCoverImageTap(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddBookViewController.imageOnTap(_:)))
        
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.coverImage.addGestureRecognizer(tap)
        self.coverImage.isUserInteractionEnabled = true
        
    }
    
    @objc func imageOnTap(_ sender: UITapGestureRecognizer){
        fetchImage()
    }
    

    
    lazy var addBookItemBar: UIBarButtonItem = {
        let image =  UIImage(named: "addBooksIcon.png")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(AddBookViewController.addBookAction(_:)))
        
        self.navigationItem.rightBarButtonItem = button

        return button
    }()

    func clearAllTextFromTextField(){
        bookTitle.text = ""
        author.text = ""
        publisher.text = ""
        locationInLibrary.text = ""
        numberOfCopies.text = ""
        callNumber.text = ""
        yearOfPublication.text = ""
        currentStatus.text = ""
        keywords.text = ""
    }
    
    func addBookAction(_ sender: Any){
        Logger.log(clzz: "AddBookViewController", message: "addBookAction")
        
        if Mock.isMockMode {
            self.librarian = Mock.mock_Librarian()
            self.add(with: Mock.mock_Book())
        }else{
            if let book = self.buildBook(){
              
                self.add(with: book)
            }
        }
    }

    
    override func loadView() {
        super.loadView()
        self.title = "Add Book"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentStatus.delegate = self
        self.currentStatus.tag = 1
        
        
        
        addBookItemBar.isEnabled = true
        initCoverImageTap()
        if let librarian = AppDelegate.fetchLibrarian(){
            self.librarian = librarian
        }else{
            self.librarian = Mock.mock_Librarian()
        }

        // Do any additional setup after loading the view.
        
    }
    
  

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == " "){
            
            if let _ = self.keywords.text{
                
                self.keywords.text! += " "
                
                
            }
            
            return false
        }
        
        if textField.tag == 1{
            return false
        }
        
        return true
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func buildBook() -> Book? {
        guard let bookTitle = self.bookTitle.text, let author = self.author.text, let publisher = self.publisher.text, let yearOfPublication = self.yearOfPublication.text, let locationInLibrary = self.locationInLibrary.text, let numberOfCopies = self.numberOfCopies.text, let callNumber = self.callNumber.text,
            let currentStatus = self.currentStatus.text, let keywords = self.keywords.text
            else {
            
            return nil
        }
        
        let book = Book.Builder()
            .setTitle(bookTitle)
            .setAuthor(author)
            .setCallNumber( callNumber)
            .setLocationInLibrary(locationInLibrary)
            .setNumberOfCopies(Int(numberOfCopies)!)
            .setYearOfPublication( Int(yearOfPublication)!)
            .setPublisher(publisher)
            .setBookStatus(currentStatus)
            .setImage(image: self.coverImage.image!)
            .setKeywords(keywords)
            .build()
        
        return book
    }
    
    func complete(event: AbstractEvent) {
        super.activityIndicatorView.stopAnimating()
        
        switch event {
        case let event as BookEvent:
            if event.state == .success{
               
                self.clearAllTextFromTextField()
                super.displayAnimateSuccess()
            }else if event.state == .exist{
                
               /* self.view.makeToast("Already contains book", point: Screen.center, title: "Error", image: UIImage(named: "error.png"), completion: nil) */
           
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
        if let librarian = self.librarian {
            super.activityIndicatorView.startAnimating()

            let event = BookEvent(librarian: librarian, book: book, action: .add)
            event.delegate = self
        }
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.pickedImage = image
       
        dismiss(animated:true, completion: fetchImageComplete)
        
        
    }
    
    var pickedImage: UIImage?
    
    // use this to do application logic
    func fetchImageComplete(){
        
        if self.getSize(image: self.pickedImage!){
            self.coverImage.image = self.pickedImage!
            //     self.showToast(message: "Image Size Too Large")
        }else{
            self.showToast(message: "Image Size Too Large")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }


}
