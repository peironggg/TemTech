//
//  RegisterViewController.swift
//  Shopee
//
//  Created by Wu Peirong on 21/10/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework
import JGProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Register"

        nameTextField.backgroundColor = FlatBlack().lighten(byPercentage: 0.80)
        nameTextField.textColor = FlatBlack()
        nameTextField.attributedPlaceholder = NSAttributedString(string: nameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: FlatBlack().lighten(byPercentage: 0.60)!])
        
        emailTextField.backgroundColor = FlatBlack().lighten(byPercentage: 0.80)
        emailTextField.textColor = FlatBlack()
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: FlatBlack().lighten(byPercentage: 0.60)!])
        
        passwordTextField.backgroundColor = FlatBlack().lighten(byPercentage: 0.80)
        passwordTextField.textColor = FlatBlack()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: FlatBlack().lighten(byPercentage: 0.60)!])
        
        reenterPasswordTextField.backgroundColor = FlatBlack().lighten(byPercentage: 0.80)
        reenterPasswordTextField.textColor = FlatBlack()
        reenterPasswordTextField.attributedPlaceholder = NSAttributedString(string: reenterPasswordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: FlatBlack().lighten(byPercentage: 0.60)!])
        
        addressTextField.backgroundColor = FlatBlack().lighten(byPercentage: 0.80)
        addressTextField.textColor = FlatBlack()
        addressTextField.attributedPlaceholder = NSAttributedString(string: addressTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: FlatBlack().lighten(byPercentage: 0.60)!])
        
        phoneTextField.backgroundColor = FlatBlack().lighten(byPercentage: 0.80)
        phoneTextField.textColor = FlatBlack()
        phoneTextField.attributedPlaceholder = NSAttributedString(string: phoneTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: FlatBlack().lighten(byPercentage: 0.60)!])
        
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        
        nameTextField.inputAccessoryView = toolBar
        emailTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
        reenterPasswordTextField.inputAccessoryView = toolBar
        addressTextField.inputAccessoryView = toolBar
        phoneTextField.inputAccessoryView = toolBar
   
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if phoneTextField.text?.isEmpty == true || addressTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true || reenterPasswordTextField.text?.isEmpty == true || emailTextField.text?.isEmpty == true || nameTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "Error", message: "Please fill in the blanks.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Success"
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                
                if self.passwordTextField.text == self.reenterPasswordTextField.text {
                    if error != nil {
                        
                        let errorMessage = error?.localizedDescription
                        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("Registration Successful")
                        hud.show(in: self.view)
                        let uid = (result?.user.uid)!
                        self.ref.child("users/\(uid)/email").setValue(self.emailTextField.text!)
                        self.ref.child("users/\(uid)/address").setValue(self.addressTextField.text!)
                        self.ref.child("users/\(uid)/phone").setValue(self.phoneTextField.text!)
                        self.ref.child("users/\(uid)/name").setValue(self.nameTextField.text!)
                        
                        
                        self.performSegue(withIdentifier: "registerGoToTabBar", sender: self)
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Passwords do not match.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }

            hud.dismiss()
        }
    }
    
    
  
}
