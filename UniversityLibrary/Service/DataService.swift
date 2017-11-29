//
//  DataService.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

final class DataService{
    let BASE_URL = "https://us-central1-universitylibrary-8e17c.cloudfunctions.net/"
    
    private init(){}
    
    static let shared = DataService()
    func sendDailyAlertReminder(startDate: Double, endDate: Double,email: String, completion: ((Bool)-> ())?){
        let url = BASE_URL + "mock_scheduledEmail?twentyFiveDaysFromNowTimeInterval=\(startDate)&thirtyDaysFromNowTimeInterval=\(endDate)&email=\(email)"
        
        let requestURL = URL(string: url)
        
        if let theRequestURL = requestURL{
            let urlRequest = URLRequest(url: theRequestURL)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest){
                (data, response, error) -> Void in
                
                if let httpResponse = response as? HTTPURLResponse{
                    // request has been successful
                    
                    if httpResponse.statusCode == 200 {
                        
                        if let completion = completion{
                            completion(true)
                        }
                    }else{
                        
                        if let completion = completion{
                            completion(false)
                        }
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    // data is a json string 
    func returnConfirmationTransaction(data: String, email: String, completion: ((Bool) -> ())?){
        
        let url = BASE_URL+"returnBooks?data=\(data)&email=\(email)"
        
        let requestURL = URL(string: url)
        
        if let theRequestURL = requestURL{
            let urlRequest = URLRequest(url: theRequestURL)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest){
                (data, response, error) -> Void in
                
                if let httpResponse = response as? HTTPURLResponse{
                    // request has been successful
                    
                    if httpResponse.statusCode == 200 {
                        
                        if let completion = completion{
                            completion(true)
                        }
                    }else{
                        
                        if let completion = completion{
                            completion(false)
                        }
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func confirmCheckout(email: String, transactionTime: String, dueDate: String,  completion: ((Bool) -> ())?){
        
        let url = BASE_URL+"confirmCheckout?email=\(email)&transactionTime=\(transactionTime)&dueDate=\(dueDate)"
   
        let requestURL = URL(string: url)
        
        if let theRequestURL = requestURL{
            let urlRequest = URLRequest(url: theRequestURL)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest){
                (data, response, error) -> Void in
                
                if let httpResponse = response as? HTTPURLResponse{
                    // request has been successful
                    
                    if httpResponse.statusCode == 200 {
                        
                        if let completion = completion{
                            completion(true)
                        }
                    }else{
                        
                        if let completion = completion{
                            completion(false)
                        }
                    }
                }
            }
            
            task.resume()
            
        }
        
        
    }
    
    func sendEmail(email: String, message: String, subject: String, completion: ((Bool) -> () )?){
        
        let url = "https://us-central1-universitylibrary-8e17c.cloudfunctions.net/sendGeneralEmail?email=\(email)&text=\(message)&subject=\(subject)"
        
        Logger.log(clzz: "DataService", message:"url: \(url)")
        
        let requestURL = URL(string: url)
        
        if let theRequestURL = requestURL{
            let urlRequest = URLRequest(url: theRequestURL)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest){
                (data, response, error) -> Void in
                
                if let httpResponse = response as? HTTPURLResponse{
                    // request has been successful
                    
                    if httpResponse.statusCode == 200 {
                        
                        if let completion = completion{
                            completion(true)
                        }
                    }else{
                        
                        if let completion = completion{
                            completion(false)
                        }
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
   
  
}
