//
//  ViewController.swift
//  Expense
//
//  Created by Виктория Саклакова on 15.03.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    var expenses: [Expense] = [
        Expense(name: "Amsterdam", count: 100),
        Expense(name: "Wineglass", count: 1.5),
        Expense(name: "T-shirt", count: 30)
    ]
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        updateTotalSum()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchNewExpense(_ sender: UIButton) {
        let expenseName = nameTextField.text!
        let expenseAmount = Double(amountTextField.text!)!
        
        let newExpense = Expense(name: expenseName, count: expenseAmount)
        expenses.append(newExpense)
        for i in 0..<expenses.count {
            print(expenses[i])
        }
        updateTotalSum()
        self.tableView.reloadData()
    }
    func updateTotalSum(){
        var totalSum: Double = 0.0
        for i in 0..<expenses.count {
            totalSum += expenses[i].count
        }
        totalSumLabel.text = "Total Sum: \(totalSum)"
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = "\(expenses[indexPath.row].name): \(expenses[indexPath.row].count)"
        
        return cell
    }
    
    
}

