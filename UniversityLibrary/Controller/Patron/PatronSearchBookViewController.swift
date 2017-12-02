//
//  PatronSearchBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class PatronSearchBookViewController: BaseViewController, BookKeeper, AbstractEventDelegate {
    
    //MARK: Properties
    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var author: UITextField!
    
    @IBOutlet weak var publisher: UITextField!
    
    @IBOutlet weak var yearOfPublication: UITextField!
    @IBOutlet weak var locationInLibrary: UITextField!
    @IBOutlet weak var callNumber: UITextField!
    @IBOutlet weak var currentStatus: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func checkout(book: Book) {
        
    }
    
    func waiting(book: Book) {
        
    }
    
    func doReturn(book: Book) {
        
    }
    
    func doReturn(books: [Book]) {
        
    }
    
    func search(for: Book) {
        
    }
    
    func complete(event: AbstractEvent){
        
    }
    func error(event: AbstractEvent){
        
    }

   

}
