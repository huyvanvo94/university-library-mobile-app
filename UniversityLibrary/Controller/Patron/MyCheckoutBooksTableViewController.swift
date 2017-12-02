//
//  MyCheckoutBooksTableViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class MyCheckoutBooksTableViewController: UITableViewController, AbstractEventDelegate{

    var checkoutBooks = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Checked Out Books"
        self.fetchBooks()
      

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func fetchBooks(){
        
        DispatchQueue.main.async {
            
            for _ in 0..<100{
                let event = FetchCheckedOutEvent(patron: Mock.mock_Patron())
                event.delegate = self
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return checkoutBooks.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        let book = self.checkoutBooks[indexPath.row]
        
        self.goToBookViewController(with: book)
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        
        let index = indexPath.row
        
        let book = self.checkoutBooks[index]
        
        cell.bookAuthorLabel.text = book.author
        cell.bookTitleLabel.text = book.title
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
        }
    }
    
    func complete(event: AbstractEvent) {
        switch event {
        case let event as FetchCheckedOutEvent:
            
            DispatchQueue.main.sync {
                if let book = event.book{
          
                    self.checkoutBooks.append(book)
                    self.tableView.reloadData()
                }
            }
            
        default:
            print("No Action")
        }
        
    }
    
    func error(event: AbstractEvent) {
        print("Error")
    }
 
    func goToBookViewController(with book: Book){
        // PatronBookViewController
        if let bookVC = self.storyboard?.instantiateViewController(withIdentifier: "PatronBookViewController") as? PatronBookViewController{
            bookVC.book = book
            
            self.navigationController?.pushViewController(bookVC, animated: true)
        }
    }
    
}
