//
//  ChatViewController.swift
//  Shoppal
//
//  Created by Wu Peirong on 10/11/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import ChameleonFramework

class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    


    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var messageArray:[Message] = [Message]()
    
    let uid = Auth.auth().currentUser?.uid
    let email = Auth.auth().currentUser?.email

    override func viewDidLoad() {
        super.viewDidLoad()

        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        
        messageTextField.delegate = self
        
        configureTableView()
        retrieveMessages()
        
        chatTableView.separatorStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        chatTableView.addGestureRecognizer(tapGesture)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! CustomMessageCell
                cell.messageBody.text = messageArray[indexPath.row].messageBody
                cell.senderUsername.text = messageArray[indexPath.row].sender
                if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
                    cell.messageBackground.backgroundColor = FlatMint()
                }
                else {
                    cell.messageBackground.backgroundColor = FlatPink()
                }
                return cell
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    func configureTableView() {
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 120
    }
    
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages").child(uid!)
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["Message"]!
            let sender = snapshotValue["Sender"]!
            let message = Message()
            message.messageBody = text
            message.sender = sender
            self.messageArray.append(message)
            self.configureTableView()
            self.chatTableView.reloadData()
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let tick = String(format: "%.0f", Date().timeIntervalSince1970)
        
        let messagesDB = Database.database().reference().child("Messages").child(uid!)
        let messageDictionary = ["Sender": email, "Message": messageTextField.text!]
        messagesDB.child(tick).setValue(messageDictionary)  {
            (error, reference) in
            
            if error != nil {
                print(error!)
            }
                
            else {
                print("message saved successfully!")
                
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
            }
        }
    }
    
}
