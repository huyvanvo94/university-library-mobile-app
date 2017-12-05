//
//  CheckoutBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class CheckoutBookViewController: BaseViewController {
    
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

        
        self.loadBookToUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Kevin
    func loadBookToUI(){
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
            bookLocationLabel.text = "Current Location: " + location
        }
        if let copies = self.book?.numberOfCopies{
            bookCopiesLabel.text = "# of Copies: " + String(copies)
        }
        if let status = self.book?.canCheckout{
            if status{
                bookStatusLabel.text = "Status: Available";
            }else{
                bookStatusLabel.text = "Status: Not Available";
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Actions
    @IBAction func checkoutAction(_ sender: MenuUIButton) {
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
