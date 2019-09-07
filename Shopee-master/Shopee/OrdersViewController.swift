//
//  OrdersViewController.swift
//  Shopee
//
//  Created by Wu Peirong on 21/10/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import ChameleonFramework

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var ordersTableView: UITableView!
    var pendingArray: [[String]] = []
    var confirmedArray: [[String]] = []
    var deliveryArray: [[String]] = []
    var cellArray: [[String]] = []
    var pickerCountry: [String] = []
    var totalPriceArray: [Double] = []


    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        totalPriceLabel.backgroundColor = FlatBlue()
        totalPriceLabel.textColor = FlatWhite()
        totalPriceLabel.font = UIFont(name: "Roboto", size: 20)
        ref.child("users").child(uid!).child("orders").observe(.value) { (snapshot) in
            self.totalPriceArray = []
            self.pendingArray = []
            self.confirmedArray = []
            self.deliveryArray = []
            self.pickerCountry = []
            print("snapshot retrieved")
            for orders in snapshot.children.allObjects {
                let id = orders as! DataSnapshot
                print("ID: \(id.key)")
                let values = id.value as? NSDictionary
                print(values as Any)

                let payment = values?["payment"] as? Bool
                let delivery = values?["delivery"] as? Bool
                let priceString = values?["price"] as! String
                let quantityString = values?["quantity"] as! String
                let country = values?["country"] as? String
                self.pickerCountry.append(country!)
                
                if  country == "China" {
                    let price = Double(priceString)!/4.7
                    let quantity = Double(quantityString)!
                    let totalPrice = price*quantity
                    self.totalPriceArray.append(totalPrice)
                    print("X")
                }
                else if country == "USA" {
                    
                    let priceUS = Double(priceString)!*1.4
                    let quantity = Double(quantityString)!
                    let totalPriceUS = priceUS*quantity
                    self.totalPriceArray.append(totalPriceUS)
                    
                }
                let totalPriceToPay = self.totalPriceArray.reduce(0, +)
                let roundedTotalPriceToPay = String(format: "%.2f", totalPriceToPay)
                self.totalPriceLabel.text = "  Total Price: \(roundedTotalPriceToPay) SGD"
                
                if payment == false && delivery == false {
                    let order = [values!["url"],values!["price"],values!["quantity"],values!["remarks"],id.key]
                    self.pendingArray.append(order as! [String])
                    print("pendingarray: \(self.pendingArray)")

                } else if payment == true && delivery == false {
                    let order = [values!["url"],values!["price"],values!["quantity"],values!["remarks"],id.key]
                    self.confirmedArray.append(order as! [String])

                } else if payment == true && delivery == true {
                    let order = [values!["url"],values!["price"],values!["quantity"],values!["remarks"],id.key]
                    self.deliveryArray.append(order as! [String])
                }
            }
            print(self.pendingArray.count)
            print(self.confirmedArray.count)
            self.cellArray = self.pendingArray
            print(self.cellArray)
            self.ordersTableView.reloadData()
        }
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        let nib = UINib(nibName: "OrderCell", bundle: nil)
        ordersTableView.register(nib, forCellReuseIdentifier: "orderCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let id = self.cellArray[indexPath.row][4]
            self.ref.child("users").child(self.uid!).child("orders").child(id).removeValue()
            viewDidLoad()
            }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderCell
        if cellArray.isEmpty {
            cell.urlLabel.text = ""
            cell.priceLabel.text = ""
            cell.quantityLabel.text = ""
            cell.remarksLabel.text = ""
            totalPriceLabel.text = "  Total Price:"

        } else {
            cell.urlLabel.text = "url: \(cellArray[indexPath.row][0])"
            if pickerCountry[indexPath.row] == "China" {
                print(cellArray[indexPath.row][1])
                let price = Double(cellArray[indexPath.row][1])!/4.7
                let quantity = Double(cellArray[indexPath.row][2])!
                let totalPrice = price*quantity
                let roundedPrice = String(format: "%.2f", totalPrice)
                cell.priceLabel.text = "Please Pay: \(roundedPrice)"
            } else if pickerCountry[indexPath.row] == "USA" {
                let priceUS = Double(cellArray[indexPath.row][1])!*1.4
                let quantity = Double(cellArray[indexPath.row][2])!
                let totalPriceUS = priceUS*quantity
                let roundedPriceUS = String(format: "%.2f", totalPriceUS)
                cell.priceLabel.text = "Please Pay: \(roundedPriceUS)"
            }
            cell.quantityLabel.text = "Quantity: \(cellArray[indexPath.row][2])"
            cell.remarksLabel.text = "Remarks: \(cellArray[indexPath.row][3])"
        }
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 171
    }
    @IBAction func ordersSegmentedPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            cellArray = confirmedArray
            ordersTableView.reloadData()
        } else if sender.selectedSegmentIndex == 0 {
            cellArray = pendingArray
            ordersTableView.reloadData()
        } else if sender.selectedSegmentIndex == 2 {
            cellArray = deliveryArray
            ordersTableView.reloadData()
        }
    }
}

