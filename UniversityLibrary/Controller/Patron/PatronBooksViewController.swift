//
//  PatronBooksViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/4/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class PatronBooksViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, AbstractEventDelegate, BookKeeper {
 
    var reciept: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    var patron: Patron?
    
    var isCheckoutMode = false
    var numberOfBooksCheckedOut: Int = 0
    
    var bookToCheckoutIndex: Int?
    var booksFromDatabase = [Book]()
    
    var toRemoveIndexAt = [Int: Int]()
    
    lazy var checkoutBooksButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 10, y: Screen.height - 50, width: 44, height: 44))
        button.backgroundColor = UIColor(rgb: 0x4286f4)
        button.setImage(UIImage(named: "allBooksIcon.png"), for: .normal)
        
        button.layer.cornerRadius = 10;
        button.isHidden = true
        
        button.addTarget(self, action: #selector(PatronBooksViewController.checkoutBooksAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(button)
        return button
    }()
    
    func checkoutBooksAction(_ sender: Any){
       
        Logger.log(clzz: "PatronBooksVC", message: "checkout action")
        self.toggle()
        
        DispatchQueue.main.async {
            var books = [Book]()
            
            for (index, book) in self.booksFromDatabase.enumerated().reversed(){
                if book.toggle{
                    
                    
                    books.append(book)
                }
                
            }
            
            self.numberOfBooksCheckedOut = books.count
            
            for book in books{
                
                self.checkout(book: book)
            }
            
            
            self.tableView.reloadData()
            
            // logic to return books to firebase
          
        }
        
   
    }
    
    @IBAction func toggleAction(_ sender: Any) {
        self.toggle()
    }
    
    
    func toggle(){
        numberOfBooksCheckedOut = 0
        isCheckoutMode = !isCheckoutMode
        
        if isCheckoutMode{
            //   tableView.allowsSelection = true
            tableView.allowsMultipleSelection = true
            self.checkoutBooksButton.isHidden = false
            
        }else{
            self.checkoutBooksButton.isHidden = true
            
            self.resetAccessoryType()
            tableView.allowsMultipleSelection = false
        }
        
    }
    
    override func loadView() {
   
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let patron = AppDelegate.fetchPatron(){
            self.patron = patron
        }else{
            self.patron = Mock.mock_Patron()
        }
        
        self.initTableView()
      
        self.title = "Library"
        self.initCheckoutAction()
     
       
       // let event = FetchAllBooksIdEvent()
        let event = FetchBooksEvent()
        event.delegate = self
        
        
    }
    
    private func initTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    private func initCheckoutAction(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(checkoutBookMessage))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }

    @objc func checkoutBookMessage(){
        let alert = UIAlertController(title: "Checkout", message: "Checkout book?",  preferredStyle: .actionSheet)
        let checkoutBook = UIAlertAction(title: "Confirm", style: .destructive, handler: checkoutBookHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
        alert.addAction(checkoutBook)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
 
    
    func waitlistBookHandler(_ alertAction:UIAlertAction!) -> Void{
        if let _ = self.bookToCheckoutIndex{
            let book = self.booksFromDatabase[self.bookToCheckoutIndex!]
            
            self.waiting(book: book)
        }
    }
    
    func checkoutBookHandler(_ alertAction: UIAlertAction!) -> Void{
        
        if let _ = self.bookToCheckoutIndex{
            
            self.booksFromDatabase.remove(at: self.bookToCheckoutIndex!)
            self.tableView.reloadData()
            super.displayAnimateSuccess()
        }
    }
    
    func cancelHandler(_ alertAction: UIAlertAction!) -> Void{
        self.bookToCheckoutIndex = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return booksFromDatabase.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
      
        let index = indexPath.row
        if self.isCheckoutMode{
        
            self.numberOfBooksCheckedOut -= 1
            self.booksFromDatabase[index].toggle = false
            self.tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
            
        }else{
            
        }
        
        
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isCheckoutMode{
            // allow 3 books to be checkout
            
            if (self.patron?.numberOfBooksCheckoutToday)! < 3 || self.numberOfBooksCheckedOut < 3{
                
                let index = indexPath.row
                    
                self.numberOfBooksCheckedOut += 1
                self.booksFromDatabase[index].toggle = true
                    
                self.tableView.cellForRow(at: indexPath )?.accessoryType = .checkmark
                
            }
            else{
                self.showToast(message: "3 per day!")
            }
            
           
        }else {
            self.bookToCheckoutIndex = indexPath.row
            self.tableView.deselectRow(at: indexPath, animated: true)
         
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutBookViewController") as? CheckoutBookViewController{
                vc.book = self.booksFromDatabase[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        
        let index = indexPath.row
        let book = self.booksFromDatabase[index]
        cell.bookAuthorLabel.text = book.author
        cell.bookTitleLabel.text = book.title
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .none
    }
    
    func doReturn(book: Book){
        
    }
    
    func doReturn(books: [Book]){
        
    }
    
    func checkout(book: Book) {
        Logger.log(clzz: "PatronBooksVC", message: "checkout")
        
        let checkout = CheckoutList(patron: self.patron!, book: book)
        let event = CheckoutListEvent(checkoutList: checkout)
        event.delegate = self
    }
    
    func waiting(book: Book) {
        let waitingList = WaitingList(book: book, patron: self.patron!)
        
        let event = WaitingListEvent(waitingList: waitingList, action: .add)
        event.delegate = self
        
    }
     
    func complete(event: AbstractEvent) {
        self.activityIndicatorView.stopAnimating()
        switch event {
        case let event as CheckoutListEvent:
            
            self.numberOfBooksCheckedOut -= 1
            
            if event.state == .full{
                // show add to wait list
                let alert = UIAlertController(title: "Wait List", message: "Would you like to be added to wait list?",  preferredStyle: .actionSheet)
                
                let yes = UIAlertAction(title: "Yes", style: .destructive, handler: {(handler) in
                    let book = event.checkoutList.book
                    self.waiting(book: book)
                    self.showToast(message: "Success")
                })
                let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(yes)
                alert.addAction(no)
                present(alert, animated: true, completion: nil)
            }else if event.state == CheckoutState.contain {
                
                if let index = self.booksFromDatabase.index(of: event.checkoutList.book){
                    self.booksFromDatabase[index].toggle = false 
                }
                
             //   super.alertMessage(title: "Already checkout", message: event.checkoutList.book.title!)
 
            }else if event.state == CheckoutState.success{
                
                super.displayAnimateSuccess()
                
                // create view
                if let info = event.transactionInfo{
                    let transactionString = "Book: \(event.checkoutList.book.title!)  \nDue Date: \(info.dueDate)\n"
                    self.reciept += transactionString
                }
                
                if self.numberOfBooksCheckedOut == 0{
                    
                    super.alertMessage(title: "Checkout Info", message: self.reciept)
                    
                }
            }
            
        case let event as WaitingListEvent:
            
            if event.state == WaitingListState.success{
                self.displayAnimateSuccess()
                
            }
            
        case let event as FetchBooksEvent:
            if let book = event.book{
                DispatchQueue.main.async {
                    
                    self.booksFromDatabase.append(book)
                    self.tableView.reloadData()
                }
            }
            
        case let event as FetchAllBooksIdEvent:
            
            if !event.ids.isEmpty{
                
                DispatchQueue.main.async {
                    
                    for id in event.ids{
                        
                        let event = FetchBookEvent(id: id)
                        event.delegate = self
                        
                    }
                }
                
            }
            
        case let event as FetchBookEvent:
            
            if let book = event.book{
                self.booksFromDatabase.append(book)
                self.tableView.reloadData()
                
            }
        default:
            print("No action")
        }
    }
    
    
    func search(for: Book){
        
    }
    
    func search(exact book: Book){
        
    }
    
    func error(event: AbstractEvent) {
     
        self.activityIndicatorView.stopAnimating()
        self.displayAnimateError()
        
    
    }
    func fetch(book: Book) {
        
    }
    
    func fetch() {
        
    }
    
    func doRenew(book: Book) {
        
    }

    func checkout(books: [Book]){

    }
    
    func resetAccessoryType(){
        for section in 0..<self.tableView.numberOfSections{
            for row in 0..<self.tableView.numberOfRows(inSection: section){
                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section))
                cell?.accessoryType = .none
            }
        }
    }
        
}
