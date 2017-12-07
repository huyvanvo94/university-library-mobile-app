//
//  MyWaitListTableViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

// Turn to ViewController

class MyWaitListTableViewController: UITableViewController, AbstractEventDelegate {

    var myWaitListBooks = [Book]()
    
    override func loadView() {
        super.loadView()
        self.title = "My Wait List"
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<5{
            myWaitListBooks.append(Mock.mock_Book())
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    private func fetchBooks(){
        
        DispatchQueue.main.async {
            
            for _ in 0..<100{
                let event = FetchWaitListBookEvent(patron: Mock.mock_Patron())
                event.delegate = self
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.myWaitListBooks.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("row selected: \(indexPath.row)")
 
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as!
            BookCell
        
        let index = indexPath.row
        let book = self.myWaitListBooks[index]
        cell.bookTitleLabel.text = book.title
        cell.bookAuthorLabel.text = book.author
         
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
        }
    }
    func complete(event: AbstractEvent) {
        switch event {
        case let event as FetchWaitListBookEvent:
            
            DispatchQueue.main.sync {
                if let book = event.book{
                    
                    self.myWaitListBooks.append(book)
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
}
