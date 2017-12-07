//
//  MyCheckoutBooksViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/4/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class MyCheckoutBooksViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, AbstractEventDelegate, BookKeeper {
  

    var patron: Patron?

    var checkoutBooks = [Book]()
    var editMode = false
    
    var returnBookCount = 0
    
    lazy var returnBooksButton: UIButton = {
     
        let button = UIButton(frame: CGRect(x: 10, y: Screen.height - 50, width: 44, height: 44))
        button.backgroundColor = UIColor(rgb: 0x4286f4)
        button.setImage(UIImage(named: "allBooksIcon.png"), for: .normal)
      
        button.layer.cornerRadius = 10;
        button.isHidden = true
       
        button.addTarget(self, action: #selector(MyCheckoutBooksViewController.returnBooksAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(button)
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Books"
        
        if let patron = AppDelegate.fetchPatron(){
            self.patron = patron
        }else{
            self.patron = Mock.mock_Patron()
        }

        self.initTableView()
   
        
        self.fetchBooks()

        // Do any additional setup after loading the view.
    }
    
    private func initTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func returnBooksAction(_ sender: UIButton){
        // turns off edit mode
        toggleEditMode()
        
        DispatchQueue.main.async {
            var books = [Book]()
        
            for (index, book) in self.checkoutBooks.enumerated().reversed(){
                if book.toReturn{
                    books.append(book)
                    self.checkoutBooks.remove(at: index)
                    self.tableView.reloadData()
                }
            }
            
            self.tableView.reloadData()
         
            
            // logic to return books to firebase
           
            self.doReturn(books: books)
         }
        
        super.displayAnimateSuccess()
       
    }
    
    private func toggleEditMode(){
        self.returnBookCount = 0
        editMode = !editMode
        
        if editMode{
            //   tableView.allowsSelection = true
            tableView.allowsMultipleSelection = true
            self.returnBooksButton.isHidden = false
            
        }else{
            self.returnBooksButton.isHidden = true
            
           
            self.resetAccessoryType()
            tableView.allowsMultipleSelection = false
        }
        
    }
    
    @IBAction func toggleEdit(_ sender: Any) {

        toggleEditMode()
    }
    
    
    func fetchBooks(){
        
        DispatchQueue.main.async {
            
            self.checkoutBooks = [Book]()
            self.tableView.reloadData()

            if Mock.isMockMode{

                self.patron = Mock.mock_Patron()

                self.fetch()

            }else {

                self.fetch()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return checkoutBooks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        
        let index = indexPath.row
        let book = self.checkoutBooks[index]
        
        cell.bookAuthorLabel.text = book.author
        cell.bookTitleLabel.text = book.title
       
       
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .none
    }
    func complete(event: AbstractEvent) {
        switch event {
        case let event as FetchBookEvent:
            
            if let book = event.book{
                
                self.checkoutBooks.append(book)
                self.tableView.reloadData()
            }
           
        case let event as ReturnBooksEvent:
            
            if event.state == ReturnBooksState.success{
                self.showToast(message: "Success")
            }
            
        default:
            print("No Action")
        }
        
    }
    
    func error(event: AbstractEvent) {
        print("Error")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
        let index = indexPath.row
        if editMode{
            self.returnBookCount -= 1
            self.checkoutBooks[index].toReturn = false
            self.tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
   
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if editMode{
            // allow 9 books to be returned
            if self.returnBookCount < 9{
                let index = indexPath.row
                
                self.returnBookCount += 1
                self.checkoutBooks[index].toReturn = true
                
                self.tableView.cellForRow(at: indexPath )?.accessoryType = .checkmark
            }else{
                super.showToast(message: "max is 9!")
            }
        }else {
            self.tableView.deselectRow(at: indexPath, animated: true)
            let book = self.checkoutBooks[indexPath.row]
            self.goToBookViewController(with: book)
        }
    }
    func resetAccessoryType(){
        for section in 0..<self.tableView.numberOfSections{
            for row in 0..<self.tableView.numberOfRows(inSection: section){
                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section))
                cell?.accessoryType = .none
            }
        }
    }
    
    func goToBookViewController(with book: Book){
        // PatronBookViewController
        if let bookVC = self.storyboard?.instantiateViewController(withIdentifier: "PatronBookViewController") as? PatronBookViewController{
            bookVC.book = book
            
            self.navigationController?.pushViewController(bookVC, animated: true)
        }
    }



    func checkout(book: Book){

    }
    func waiting(book: Book){

    }
    // bad function
    func doReturn(book: Book){
        if let patron = self.patron {
            let event = ReturnBookEvent(patron: patron, book: book)
            event.delegate = self
        }
    }
    
    func doReturn(books: [Book]){
        if let patron = self.patron {
            let event = ReturnBooksEvent(patron: patron, books: books)
            event.delegate = self
        }
    }
    func search(for: Book){

    }
    
    func search(exact book: Book){
        
        
    }

    func fetch(book: Book){

    }
    
    func doRenew(book: Book) {
        
    }


    func fetch(){

        Logger.log(clzz: "MyCheckoutBooksVC", message: "fetch")

        self.patron = AppDelegate.fetchPatron()!
        if let patron = self.patron{
            
            // must update patron runtime
            for key in patron.booksCheckedOut {
                
                let event = FetchBookEvent(key: key)
                event.delegate = self

            }
        }

    }
 

}
