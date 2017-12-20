//
//  LibraryViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

// Main
class PatronLibraryViewController: BaseViewController, BookManager, AbstractEventDelegate {
 
    override func loadView() {
        super.loadView()
        self.title = "Welcome"
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logout(_ sender: UIBarButtonItem) {
    
        let event = SignoutUserEvent()
        event.delegate = self
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let root = mainStoryboard.instantiateViewController(withIdentifier: "NavRootViewController") as! NavRootViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = root
   
        
    }
    
    func search(by book: Book){
        
    }
    func add(with book: Book){
        
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
    
    func complete(event: AbstractEvent) {
        
    }
    
    func error(event: AbstractEvent) {
 
    }

 

    func checkout(books: [Book]){

    }

}
