//
//  PhoneNumberViewController.swift
//  Shopee
//
//  Created by Wu Peirong on 22/10/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneNumberViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    

    @IBAction func sendCodePressed(_ sender: Any) {
        if phoneTextField.text != nil {
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneTextField.text!, uiDelegate: nil) { (VerificationID, error) in
                
            }
        }
    }
    
}
