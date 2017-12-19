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
    }

    
    @IBAction func deleteBookAction(_ sender: UIBarButtonItem) {
     
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

            if let status = self.book?.bookStatus{
                bookStatusTextField.text = status
            }
            if let callNumber = self.book?.callNumber{
                bookCallNumberTextField.text = callNumber
            }
            
           
            if let _ = self.book?.base64Image{
                print("OK")
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
    
    
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
