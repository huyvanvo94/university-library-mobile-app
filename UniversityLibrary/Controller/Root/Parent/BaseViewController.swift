//
//  BaseViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/18/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        
        // Set Center
        var center = self.view.center
        if let navigationBarFrame = self.navigationController?.navigationBar.frame {
            center.y -= (navigationBarFrame.origin.y + navigationBarFrame.size.height)
        }
        activityIndicatorView.center = center
        
        self.view.addSubview(activityIndicatorView)
        return activityIndicatorView
    }()
    
    func displayAnimateSuccess(){
    
        // toast presented with multiple options and with a completion closure
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
   
       // let center = CGPoint(x: w/2, y: h/2)
        
        let image = UIImage(named: "success.png")
        let imageView = UIImageView(image: image)
        
        imageView.frame.origin.x = w/2 - 10
        imageView.frame.origin.y = h/2 
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = false
        self.view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
            imageView.alpha = 0.0
        }) { (finished: Bool) in
            imageView.removeFromSuperview()
        }
    }
    
    
    func alertMessage(title: String, message: String, actionTitle: String = "OK"){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func popbackview(){
        self.navigationController?.popViewController(animated: true)
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
