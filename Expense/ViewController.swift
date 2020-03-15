//
//  ViewController.swift
//  Expense
//
//  Created by Виктория Саклакова on 15.03.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var totalSum = 0{
        didSet{ //updating var value
            totalSumLabel.text = "Total Sum: \(totalSum)"
        }
    }
    
    @IBOutlet weak var totalSumLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchNewExpense(_ sender: UIButton) {
        totalSum += 1
    }
    
}

