//
//  BookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit
class LibrarianBookViewController: BaseViewController, BookManager, BookCRUDDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate{

    var librarian: Librarian?
    var book: Book?
    
    // determine if textfield needs to change
    var positionChange = false

    var editOn = false
    //Outlets
    @IBOutlet weak var bookTitleTextField: CustomUITextField!
    @IBOutlet weak var bookAuthorTextField: CustomUITextField!
    @IBOutlet weak var bookPublisherTextField: CustomUITextField!
    @IBOutlet weak var bookLocationTextField: CustomUITextField!
    @IBOutlet weak var bookStatusTextField: StatusTextField!
    @IBOutlet weak var bookCallNumberTextField: CustomUITextField!
    // image of book
    @IBOutlet weak var coverImage: UIImageView!
    //outlet for stackview to change its position
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lastUpdatedLabel: GeneralUILabel!
    @IBOutlet weak var lastUpdatedEmailLabel: GeneralUILabel!
    
    
    func initView(){
         
        
        //init delegates
        bookTitleTextField.delegate = self
        bookAuthorTextField.delegate = self
        bookPublisherTextField.delegate = self
        bookLocationTextField.delegate = self
        bookStatusTextField.delegate = self
        bookCallNumberTextField.delegate = self
    }
    
    override func loadView() {
        super.loadView()
        
        self.initView()
     
        self.disableTextViewInput()
     
        self.navigationController?.isToolbarHidden = false
      
        self.initCoverImageTap()
        self.loadBookToView()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      
        switch textField {
        case bookAuthorTextField, bookTitleTextField:
            return true
        default:
          
            stackView.frame.origin.y -= 100
            coverImage.frame.origin.y -= 100
        
            self.positionChange = true
        
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func initCoverImageTap(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LibrarianBookViewController.imageOnTap(_:)))
        
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.coverImage.addGestureRecognizer(tap)
      
        
    }
    
    @objc func imageOnTap(_ sender: UITapGestureRecognizer){
        self.fetchImage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let librarian = AppDelegate.fetchLibrarian(){
            self.librarian = librarian
        }else{
            self.librarian = Mock.mock_Librarian()
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editBookAction(_ sender: UIBarButtonItem) {

        Logger.log(clzz: "LibrariranVC", message: "edit action")
        if !editOn{
            self.enableTextViewInput()
            self.coverImage.isUserInteractionEnabled = true
            editOn = true
            return
        }
        
   
        if let book = self.book{
      
            if self.buildUpdatedBook(){
                self.update(book: book)
            }
        }


    }

    func buildUpdatedBook() -> Bool{

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
        if let callNumber = bookCallNumberTextField.text{
            newBook.callNumber = callNumber
        }

        if let bookStatus = self.bookStatusTextField.text{
            
            newBook.bookStatus = bookStatus
        }

        if let image = self.coverImage.image{
            newBook.base64Image = newBook.base64Str(image: image)
        }
        
        
        self.book?.updateBook = newBook
        
        return true
    }

    
    @IBAction func deleteBookAction(_ sender: UIBarButtonItem) {
     
        if let book = self.book{
            super.activityIndicatorView.startAnimating()
          
            self.delete(book: book)
        }
    
    }
    
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

            if let status = self.book?.bookStatus{
                bookStatusTextField.text = status
            }
            if let callNumber = self.book?.callNumber{
                bookCallNumberTextField.text = callNumber
            }
            
           
            if let _ = self.book?.base64Image{
               
                coverImage.image = self.book?.image!
            }
            if let lastUpdated = self.book?.lastUpDateBy{
                lastUpdatedLabel.isHidden = false
                lastUpdatedEmailLabel.isHidden = false
                lastUpdatedEmailLabel.text = lastUpdated
            }
         
          

            
        }
    }

    // allow text view to be edit about
    func disableTextViewInput(){
        bookTitleTextField.makeNotEditable()
        bookAuthorTextField.makeNotEditable()
        bookPublisherTextField.makeNotEditable()
        bookLocationTextField.makeNotEditable()
        bookCallNumberTextField.makeNotEditable()
        bookStatusTextField.makeNotEditable()
    }

    
    func enableTextViewInput(){
        bookTitleTextField.makeEditable()
        bookTitleTextField.makeEditable()
        bookAuthorTextField.makeEditable()
        bookPublisherTextField.makeEditable()
        bookLocationTextField.makeEditable()
        bookCallNumberTextField.makeEditable()
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
        Logger.log(clzz: "LibrarianBookViewController", message: "update")
        if let librarian = self.librarian {
            
            self.activityIndicatorView.startAnimating()
            
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
                   
                    self.popBackView()
                 //  self.navigationController?.popToRootViewController(animated: true)
                 }else if event.state == BookActionState.checkoutListNotEmpty{

                    self.alertMessage(title: "Error", message: "Book is currently checked out")
                
                }
                    
                    
            }
        }
        
    }
    
    func error(event: AbstractEvent) {
        
        DispatchQueue.main.async {
        
            self.activityIndicatorView.stopAnimating()
            self.alertMessage(title: "Error", message: "error code 404")
            
        }
        
    }
    
    func result(exact book: Book){
        
     
    }
    
    func fetchImage(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
         
            self.present(imagePicker, animated: true, completion: nil)
        }
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
            
        }else{
            self.alertMessage(title: "Error", message: "image Size too large!")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    func animateViewMoving(_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
 
        
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
   
}
