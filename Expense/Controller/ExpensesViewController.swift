//
//  ViewController.swift
//  Expense
//
//  Created by Виктория Саклакова on 15.03.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class ExpensesViewController: UIViewController, ExpenseViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalSumLabel: UILabel!
    
    var expenses: [Expense] = [
        Expense(name: "Amsterdam", count: 100),
        Expense(name: "Wineglass", count: 1.5),
        Expense(name: "T-shirt", count: 30)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        updateTotalSum()
    }
    
    func updateTotalSum(){
        var totalSum: Double = 0.0
        for expense in expenses {
            totalSum += expense.count
        }
        totalSumLabel.text = "Total Sum: \(totalSum)"
    }
    
    @IBAction func touchNewExpense(_ sender: UIButton) {
        let controller : NewExpenseViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewExpenseVC") as! NewExpenseViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func addNewExpenseTouched(newExpense: Expense){
        expenses.append(newExpense)
        updateTotalSum()
        self.tableView.reloadData()
    }
}

extension ExpensesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = "\(expenses[indexPath.row].name): \(expenses[indexPath.row].count)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {

        self.expenses.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        updateTotalSum()
      }
    }
}

