//
//  SubmitOrderViewController.swift
//  Shopee
//
//  Created by Wu Peirong on 22/10/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import ChameleonFramework
import SimpleCheckbox

class SubmitOrderViewController: UIViewController {

    @IBOutlet weak var chinaCheckBox: Checkbox!
    @IBOutlet weak var usaCheckBox: Checkbox!
    @IBOutlet weak var airCheckBox: Checkbox!
    @IBOutlet weak var seaCheckBox: Checkbox!
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var remarksTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chinaCheckBox.checkmarkStyle = .tick
        chinaCheckBox.checkmarkColor = .black
        chinaCheckBox.checkedBorderColor = .black
        chinaCheckBox.uncheckedBorderColor = .black
        
        usaCheckBox.checkmarkStyle = .tick
        usaCheckBox.checkmarkColor = .black
        usaCheckBox.checkedBorderColor = .black
        usaCheckBox.uncheckedBorderColor = .black
        
        airCheckBox.checkmarkStyle = .tick
        airCheckBox.checkmarkColor = .black
        airCheckBox.checkedBorderColor = .black
        airCheckBox.uncheckedBorderColor = .black
        
        seaCheckBox.checkmarkStyle = .tick
        seaCheckBox.checkmarkColor = .black
        seaCheckBox.checkedBorderColor = .black
        seaCheckBox.uncheckedBorderColor = .black
        
        priceTextField.keyboardType = .asciiCapableNumberPad
        quantityTextField.keyboardType = .asciiCapableNumberPad

        view.backgroundColor = HexColor("#e8f4f8")
        submitButton.backgroundColor = FlatOrange()
        submitButton.setTitleColor(FlatWhite(), for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Roboto", size: 20)

        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        urlTextField.inputAccessoryView = toolBar
        priceTextField.inputAccessoryView = toolBar
        quantityTextField.inputAccessoryView = toolBar
        remarksTextField.inputAccessoryView = toolBar
        

    }
    
    
    @IBAction func submitOrderPressed(_ sender: Any) {

            if self.urlTextField.text?.isEmpty == false && self.priceTextField.text?.isEmpty == false && self.quantityTextField.text?.isEmpty == false && self.remarksTextField.text?.isEmpty == false {
                let alertFirst = UIAlertController(title: "Warning", message: "Are you sure you want to submit?", preferredStyle: .alert)
                let alertAction2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertFirst.addAction(alertAction2)
                let alertActionFirst = UIAlertAction(title: "Confirm", style: .default) { (action) in

                    let ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("orders").childByAutoId()
                    ref.setValue(["url":self.urlTextField.text!,"price":self.priceTextField.text!,"quantity":self.quantityTextField.text!,"remarks":self.remarksTextField.text!,"payment":false,"delivery":false])
                    
                    if self.chinaCheckBox.isChecked == true {
                        ref.child("country").setValue("China")
                    } else if self.usaCheckBox.isChecked == true {
                        ref.child("country").setValue("USA")
                    } else if self.chinaCheckBox.isChecked == true && self.usaCheckBox.isChecked == true {
                        let alert = UIAlertController(title: "Error", message: "Please check only one box.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Please check the country.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    if self.airCheckBox.isChecked == true {
                        ref.child("shipping").setValue("Air")
                    } else if self.seaCheckBox.isChecked == true {
                        ref.child("shipping").setValue("Sea")
                    } else if self.airCheckBox.isChecked == true && self.seaCheckBox.isChecked == true {
                        let alert = UIAlertController(title: "Error", message: "Please check only one box.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Please check the shipping.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }
        
                alertFirst.addAction(alertActionFirst)
                self.present(alertFirst, animated: true, completion: nil)
               
            } else {
                let alert = UIAlertController(title: "Error", message: "Please fill in the blanks.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            }

        }

    }
    

