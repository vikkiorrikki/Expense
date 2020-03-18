//
//  ViewController.swift
//  Expense
//
//  Created by Виктория Саклакова on 15.03.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class ExpensesViewController: UIViewController {

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
        // Do any additional setup after loading the view.
    }
    
    func updateTotalSum(){
        var totalSum: Double = 0.0
        for i in 0..<expenses.count {
            totalSum += expenses[i].count
        }
        totalSumLabel.text = "Total Sum: \(totalSum)"
    }
    
    @IBAction func touchNewExpense(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAddNewExpense", sender: self)
    }
    
    @IBAction func addNewExpenseToTableView(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "goBackFromAddNewExpense" else {
            return
        }
        guard let source = unwindSegue.source as? NewExpenseViewController else { return }
        let newExpense = Expense(name: source.expenseName ?? "", count: source.expenseAmount ?? 0.0)
        expenses.append(newExpense)
        for i in 0..<expenses.count {
            print(expenses[i])
        }
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

