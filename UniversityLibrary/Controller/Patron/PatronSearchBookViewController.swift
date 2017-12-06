//
//  PatronSearchBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class PatronSearchBookViewController: BaseViewController, BookKeeper, AbstractEventDelegate {
    func fetch(book: Book) {
        
    }
    
    func fetch() {
        
    }
    
    
    //MARK: Properties
    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var author: UITextField!
    
    @IBOutlet weak var publisher: UITextField!
    
    @IBOutlet weak var yearOfPublication: UITextField!
    @IBOutlet weak var locationInLibrary: UITextField!
    @IBOutlet weak var callNumber: UITextField!
    @IBOutlet weak var currentStatus: UITextField!
    
    override func loadView() {
        super.loadView()
        self.title = "Search"
    }
    
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
 
    @IBAction func searchForBook(_ sender: UIButton) {
        
        goToCheckoutBookVC(with: Mock.mock_Book())
    }
    
    
   
   

    func goToCheckoutBookVC(with book: Book ){
        //CheckoutBookViewController
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutBookViewController") as? CheckoutBookViewController{
            
           self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
