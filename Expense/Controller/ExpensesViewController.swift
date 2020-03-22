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
    let defaults = UserDefaults.standard
    let keyForUserDefaults = "savedExpenses"
    
    var expenses = [Expense]()
        /*Expense(name: "Amsterdam", count: 100),
        Expense(name: "Wineglass", count: 1.5),
        Expense(name: "T-shirt", count: 30)
    ]*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        updateTotalSum()
        
        if let data = defaults.value(forKey: keyForUserDefaults){
            expenses = try! PropertyListDecoder().decode([Expense].self, from: data as! Data)
        }else{
            print("error decode")
        }
        print(expenses)
    }
    /*override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }*/
    
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
        
        defaults.set(try? PropertyListEncoder().encode(expenses), forKey: keyForUserDefaults)
        defaults.synchronize()
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
        
//        defaults.remov
      }
    }
}

