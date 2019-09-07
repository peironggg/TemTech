//
//  HomeViewController.swift
//  Shopee
//
//  Created by Wu Peirong on 21/10/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import UIKit
import ChameleonFramework

class HomeViewController: UIViewController {

    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var instructionsImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = HexColor("#e8f4f8")
        
        instructionsImage.image = UIImage(named: "Home")
        
        paymentButton.backgroundColor = FlatOrange()
        paymentButton.setTitleColor(FlatWhite(), for: .normal)
        paymentButton.titleLabel?.font = UIFont(name: "Roboto", size: 20)

        orderButton.backgroundColor = FlatOrangeDark()
        orderButton.setTitleColor(FlatWhite(), for: .normal)
        orderButton.titleLabel?.font = UIFont(name: "Roboto", size: 20)
    }
    

    @IBAction func submitPaymentPressed(_ sender: Any) {
    }
    
    @IBAction func submitOrderPressed(_ sender: Any) {
    }
    
}
