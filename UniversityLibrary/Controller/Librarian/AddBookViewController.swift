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


class AddBookViewController: BaseViewController, BookCRUDDelegate, BookManager, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate{

    // determine if textfield needs to change
    var positionChange = false
    
    var librarian: Librarian?
    // outlets
    @IBOutlet weak var scollView: UIScrollView!
    
    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var publisher: UITextField!
    @IBOutlet weak var yearOfPublication: UITextField!
    @IBOutlet weak var locationInLibrary: UITextField!
    @IBOutlet weak var numberOfCopies: UITextField!
    @IBOutlet weak var callNumber: UITextField!
    
    @IBOutlet weak var currentStatus: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
 
    @IBOutlet weak var stackView: UIStackView!
     
    @IBOutlet weak var keywords: GeneralTextArea!
    
    func hideKeyboard(){
        bookTitle.resignFirstResponder()
        author.resignFirstResponder()
        publisher.resignFirstResponder()
        yearOfPublication.resignFirstResponder()
        locationInLibrary.resignFirstResponder()
        numberOfCopies.resignFirstResponder()
        callNumber.resignFirstResponder()
        currentStatus.resignFirstResponder()
        keywords.resignFirstResponder()
        
    }
    
    func initView(){
        bookTitle.delegate = self
        author.delegate = self
        publisher.delegate = self
        yearOfPublication.delegate = self
        yearOfPublication.delegate = self
        locationInLibrary.delegate = self
        numberOfCopies.delegate = self
        callNumber.delegate = self
        currentStatus.delegate = self
        keywords.delegate = self
        
       
        self.scollView.hideIndicators()
       
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
    
    // cover image tap
    func initCoverImageTap(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddBookViewController.imageOnTap(_:)))
        
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.coverImage.addGestureRecognizer(tap)
        self.coverImage.isUserInteractionEnabled = true
        
    }
    
    // fetch image
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
 
        if let book = self.buildBook(){
            self.add(with: book)
        }else{
            self.showToast(message: "Invalid inputs!")
            self.clearAllTextFromTextField()
        }

    }

    
    override func loadView() {
        super.loadView()
        self.title = "Add Book"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: false)
      
        self.initView()
        
        addBookItemBar.isEnabled = true
        initCoverImageTap()
        if let librarian = AppDelegate.fetchLibrarian(){
            self.librarian = librarian
        }else{
            self.librarian = Mock.mock_Librarian()
        }
 
    }
    
  

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        /*
        if textField == keywords{
            if(string == " "){
                
                if let _ = self.keywords.text{
                    
                    self.keywords.text! += " "
                    
                    
                }
                
                return false
            }
        }*/
        
        
        if textField == currentStatus{
            return false
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
        textField.resignFirstResponder()
        
       
        return true
    }
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func buildBook() -> Book? {
        guard let bookTitle = self.bookTitle.text, let author = self.author.text, let publisher = self.publisher.text, let yearOfPublication = self.yearOfPublication.text?.number, let locationInLibrary = self.locationInLibrary.text, let numberOfCopies = self.numberOfCopies.text?.number, let callNumber = self.callNumber.text,
            let currentStatus = self.currentStatus.text, let keywords = self.keywords.text
            else {
            return nil
        }
        // negative number 
        if numberOfCopies < 0{
            return nil
        }
        
        let book = Book.Builder()
            .setTitle(bookTitle)
            .setAuthor(author)
            .setCallNumber( callNumber)
            .setLocationInLibrary(locationInLibrary)
            .setNumberOfCopies(numberOfCopies)
            .setYearOfPublication(yearOfPublication)
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
                self.coverImage.image = UIImage(named: "placeHolder.png")
                super.displayAnimateSuccess()
            }else if event.state == .exist{
                
                self.alertMessage(title: "Ooopse", message: "Already contains book in database")
       
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
        if let librarian = self.librarian {
            
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
        }else{
            self.showToast(message: "Image Size Too Large")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
 
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // don't allow view to move up if is book title or author
        if textField == bookTitle || textField == author {
            return
        }
        animateViewMoving(true, moveValue: 200)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // don't allow view to move down if is book title or author
        if textField == bookTitle || textField == author {
            return
        }
        animateViewMoving(false, moveValue: 200)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        animateViewMoving(true, moveValue: 200)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        animateViewMoving(false, moveValue: 200)
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
