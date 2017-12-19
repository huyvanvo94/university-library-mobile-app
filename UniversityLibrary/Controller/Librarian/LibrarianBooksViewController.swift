//
//  LibrarianBooksViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 12/5/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class LibrarianBooksViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, AbstractEventDelegate{

    var librarian: Librarian?
    @IBOutlet weak var tableView: UITableView!

    var pause = false
    var booksFromDatabase = [Book]()

    override func loadView() {

        super.loadView()
    }

    func fetch(){
        let event = FetchBooksEvent()
        event.delegate = self
    }

    func clear(){
        self.booksFromDatabase = [Book]()
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)

        if pause{

            booksFromDatabase = [Book]()
            pause = false
            self.fetch()

        }

    }

    override func viewDidLoad() {
        Logger.log(clzz: "LibrarianVC", message: "viewDidLoad")
        super.viewDidLoad()
        if let librarian = AppDelegate.fetchLibrarian(){
            self.librarian = librarian
        }else{
            self.librarian = Mock.mock_Librarian()
        }
        
        self.initTableView() 
        self.title = "Library"
       // let event = FetchAllBooksIdEvent()
        let event = FetchBooksEvent()
        event.delegate = self
 
    }

    private func initTableView(){
        tableView.delegate = self
        tableView.dataSource = self
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


    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        let book = self.booksFromDatabase[indexPath.row]
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LibrarianBookViewController") as? LibrarianBookViewController{

            self.pause = true
            vc.book = book

            self.navigationController?.pushViewController(vc, animated: true)
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


    func complete(event: AbstractEvent) {
        if self.pause == true{
            return
        }

        switch event {
        case let event as FetchBooksEvent:
            if let book = event.book{
                DispatchQueue.main.async {
                    self.booksFromDatabase.append(book)
                    self.tableView.reloadData()
                }
            }
            
            
        case let event as FetchAllBooksIdEvent:
            Logger.log(clzz: "LibrarianBooksViewController", message: "fetch all books id")

            if !event.ids.isEmpty{

                DispatchQueue.main.async {

                    for id in event.ids{

                        let event = FetchBookEvent(id: id)

                        event.delegate = self

                    }
                }

            }

        case let event as FetchBookEvent:
            Logger.log(clzz: "LibrarianBooksViewController", message: "fetch all books")

            if let book = event.book{
                self.booksFromDatabase.append(book)
                self.tableView.reloadData()

            }
        default:
            print("No action")
        }
    }
 
    @IBAction func goToSearchView(_ sender: UIBarButtonItem) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LibrarianSearchBookViewController") as? LibrarianSearchBookViewController{

            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func error(event: AbstractEvent) {

    }


}
