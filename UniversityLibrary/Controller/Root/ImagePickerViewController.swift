//
// Created by Huy Vo on 12/5/17.
// Copyright (c) 2017 Huy Vo. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var imagePicked: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()


    }

    func fetchImage(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
         //   imagePicker.modalPresentationStyle = .popover

            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {

        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imagePicked = image
        dismiss(animated:true, completion: nil)

        self.fetchImageComplete()

    }

    func fetchImageComplete(){

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

    }

}
