//
//  SubmitOrderViewController.swift
//  Shopee
//
//  Created by Wu Peirong on 22/10/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import UIKit
import ChameleonFramework
import JGProgressHUD
import FirebaseStorage
import FirebaseAuth

class SubmitPaymentViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    let uid = Auth.auth().currentUser?.uid
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(uid!)
        view.backgroundColor = HexColor("#e8f4f8")
        imageButton.backgroundColor = FlatGreen()
        imageButton.setTitleColor(FlatWhite(), for: .normal)
        imageButton.titleLabel?.font = UIFont(name: "Roboto", size: 20)
        
        submitButton.backgroundColor = FlatOrange()
        submitButton.setTitleColor(FlatWhite(), for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Roboto", size: 20)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
  
    }
    
    @IBAction func actualSubmitPaymentPressed(_ sender: Any) {
        
        if photoImageView.image == nil {
            let alert = UIAlertController(title: "Error", message: "Please upload screenshot.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alertFirst = UIAlertController(title: "Warning", message: "Are you sure you want to submit?", preferredStyle: .alert)
            let alertAction2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertFirst.addAction(alertAction2)
            let alertActionFirst = UIAlertAction(title: "Confirm", style: .default) { (action) in
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Success"
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            hud.show(in: self.view)
            let tick = String(format: "%.0f", Date().timeIntervalSince1970)
            let storageRef = Storage.storage().reference().child(self.uid!).child(tick).child("payment.jpg")
                if let uploadData = self.photoImageView.image?.jpegData(compressionQuality: 0.6) {
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error!)
                        }
                    })
                }
                
            //add upload image to firebase code here
            hud.dismiss()
            self.navigationController?.popViewController(animated: true)
            }
            alertFirst.addAction(alertActionFirst)
            self.present(alertFirst, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func uploadImagePressed(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        photoImageView.image = chosenImage
        } else {
            
        }
        self.dismiss(animated: true, completion: nil)
    }
}
