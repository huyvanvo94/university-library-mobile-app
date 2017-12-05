//
//  BookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class PatronBookViewController: BaseViewController, BookKeeper, AbstractEventDelegate {
    
    var book: Book?
    
    //Outlets
    @IBOutlet weak var bookTitleLabel: GeneralUILabel!
    @IBOutlet weak var bookAuthorLabel: GeneralUILabel!
    @IBOutlet weak var bookPublisherLabel: GeneralUILabel!
    @IBOutlet weak var bookLocationLabel: GeneralUILabel!
    @IBOutlet weak var bookCopiesLabel: GeneralUILabel!
    @IBOutlet weak var bookStatusLabel: GeneralUILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loadBookToUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadBookToUI(){
        self.title = "Book Details"
        
     
        if let title = self.book?.title{
            bookTitleLabel.text = "Title: " + title
        }
        if let author = self.book?.author{
            bookAuthorLabel.text = "Author: " + author
        }
        if let publisher = self.book?.publisher{
            bookPublisherLabel.text = "Publisher: " + publisher
        }
        if let location = self.book?.locationInLibrary{
            bookLocationLabel.text = "Location: " + location
        }
        if let copies = self.book?.numberOfCopies{
            bookCopiesLabel.text = "# of Copies: " + String(copies)
        }
        if let status = self.book?.canCheckout{
            if status{
                bookStatusLabel.text = "Status: Available"
            }else{
                bookStatusLabel.text = "Status: Not Available"
            }
        }
 
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
