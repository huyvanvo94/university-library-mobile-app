//
//  PatronBooksTableViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class PatronBooksTableViewController: BaseTableViewController, BookKeeper, AbstractEventDelegate{
    
    var patron = Mock.mock_Patron()

    var bookToCheckoutIndex: Int?
    var booksFromDatabase = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Library"
        self.initCheckoutAction()
       
        for _ in 0..<5{
            booksFromDatabase.append(Mock.mock_Book())
            
        }

 
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
    
    func waitlistBookMessage(){
        let alert = UIAlertController(title: "Waitlist", message: "Waitlist book?",  preferredStyle: .actionSheet)
        let waitlistBook = UIAlertAction(title: "Confirm", style: .destructive, handler: waitlistBookHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
        alert.addAction(waitlistBook)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return booksFromDatabase.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("row selected: \(indexPath.row)")
          self.tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        
        let index = indexPath.row
        let book = self.booksFromDatabase[index]
        cell.bookAuthorLabel.text = book.author
        cell.bookTitleLabel.text = book.title
        
        self.bookToCheckoutIndex = index
   
      
        return cell
    }
  
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
 
        return .none
    }
    
    func doReturn(book: Book){
  
    }
    
    func doReturn(books: [Book]){
     
    }
    
    func checkout(book: Book) {
        
        let checkout = CheckoutList(patron: self.patron, book: book)
        let event = CheckoutListEvent(checkoutList: checkout, action: .add)
        event.delegate = self
    }
    
    func waiting(book: Book) {
        let waitingList = WaitingList(book: book, patron: self.patron)
        
        let event = WaitingListEvent(waitingList: waitingList, action: .add)
        event.delegate = self
        
    }
    
    
    
    func complete(event: AbstractEvent) {
        switch event {
        case let event as CheckoutListEvent:
            if event.state == .full{
                
                
                self.waitlistBookMessage()
                //let book = event.checkoutList.book
                //self.waiting(book: book)
            }
            
        case let event as WaitingListEvent:
            
            if event.state == WaitingListState.success{
                
            }
            
        default:
            print("No action")
        }
    }
    
    
    func search(for: Book){
        
    }
    
    func error(event: AbstractEvent) {
        
    }
}
