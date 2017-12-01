//
//  BookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/30/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class LibrarianBookViewController: BaseViewController, BookManager, BookCRUDDelegate {

    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func search(exact book: Book) {
    
    }
    
    func search(by book: Book) {
        
        
    }
    
    func add(with book: Book) {
        
    }
    
    
    func update(book: Book) {
        
        let event = BookEvent(book: book, action: .update)
        event.delegate = self
        
    }
    
    func delete(book: Book) {
        let event = BookEvent(book: book, action: .delete)
        event.delegate = self
        
    }
    
    func complete(event: AbstractEvent) {
        
       
        if let evnt = event as? BookEvent{
            
            if evnt.state = .deleteSuccess{
                
                self.popbackview()
            }else if evnt.state = .updateSuccess{
                self.popbackview()
            }
            
        }
        
        
        
    }
    
    func error(event: AbstractEvent) {
        
    }
    
    func result(exact book: Book){
        
     
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
