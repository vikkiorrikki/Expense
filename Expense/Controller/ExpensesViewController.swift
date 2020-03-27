//
//  ViewController.swift
//  Expense
//
//  Created by Виктория Саклакова on 15.03.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit



class ExpensesViewController: UIViewController, ExpensesViewControllerDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var currentSumLabel: UILabel!
    @IBOutlet weak var neededSumLabel: UILabel!
    
    // MARK: - Properties
    
    let storageService = UserDefaultsStorageService()
    var expenses = [Expense]() {
        didSet {
            let totalSum = updateTotalSum()
            updateNeedeSum(totalSum: totalSum)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        expenses = storageService.loadExpenses()
        tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
    }
    
    // MARK: - Private methods
    
    private func updateTotalSum() -> Double {
        var totalSum: Double = 0.0
        for expense in expenses {
            totalSum += expense.amount
        }
        totalSumLabel.text = "Total Sum: \(totalSum)"
        return totalSum
    }
    
    private func updateNeedeSum(totalSum: Double) {
        let currentSum = 100.0 // will count from расход/приход
        let neddedSum = totalSum - currentSum
        neededSumLabel.text = "Needed: \(neddedSum)"
    }
    // MARK: - Actions
    
    @IBAction func touchNewExpense(_ sender: UIButton) {
        let controller : NewExpenseViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewExpenseVC") as! NewExpenseViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - ExpensesViewControllerDelegate
    
    func addNewExpenseTouched(newExpense: Expense) {
        expenses.append(newExpense)
        self.tableView.reloadData()
        
        storageService.saveExpenses(expenses)
    }
}

//MARK: - UITableViewDataSource

extension ExpensesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ExpenseCell
        cell.nameLabel.text = "\(expenses[indexPath.row].name)"
        cell.amountLabel.text = "\(expenses[indexPath.row].amount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        self.expenses.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        storageService.saveExpenses(expenses)
      }
    }
}

