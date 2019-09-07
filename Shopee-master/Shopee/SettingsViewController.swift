//
//  SettingsViewController.swift
//  Shopee
//
//  Created by Wu Peirong on 21/10/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD
import ChameleonFramework

class SettingsViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()

        signOutButton.backgroundColor = FlatRed()
        signOutButton.setTitleColor(FlatWhite(), for: .normal)
        signOutButton.titleLabel?.font = UIFont(name: "Roboto", size: 20)
        
        saveButton.backgroundColor = FlatBlueDark()
        saveButton.setTitleColor(FlatWhite(), for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Roboto", size: 20)
        
        ref.child("users").child(uid!).observe(.value) { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            print(postDict)
            if let email = postDict["email"] {
                self.emailTextField.text = email as? String
            }
            if let address = postDict["address"] {
                self.addressTextField.text = address as? String
            }
            if let phone = postDict["phone"] {
                self.phoneTextField.text = phone as? String
            }

        }
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        
        emailTextField.inputAccessoryView = toolBar
        addressTextField.inputAccessoryView = toolBar
        phoneTextField.inputAccessoryView = toolBar
    }
    

    @IBAction func signOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to sign out?", preferredStyle: .alert)
            let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { (alertAction) in
                if self.storyboard != nil {
                    let vc = UIStoryboard(name: "Start", bundle: nil).instantiateViewController(withIdentifier: "LogInID")
                    self.present(vc, animated: false, completion: nil)
                }
                }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(signOutAction)
            self.present(alert, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if emailTextField.text?.isEmpty == true || addressTextField.text?.isEmpty == true || phoneTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "Error", message: "Please fill in the blanks.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            } else {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Success"
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            hud.show(in: self.view)
            ref.child("users/\(uid!)/email").setValue(emailTextField.text!)
            ref.child("users/\(uid!)/address").setValue(addressTextField.text!)
            ref.child("users/\(uid!)/phone").setValue(phoneTextField.text!)
            hud.dismiss()
        }
    }
    

}
