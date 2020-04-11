//
//  ViewController.swift
//  Expense
//
//  Created by Виктория Саклакова on 15.03.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController, ExpensesViewControllerDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var currentSumLabel: UILabel!
    @IBOutlet weak var neededSumLabel: UILabel!
    
    // MARK: - Properties
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var expenses = [Expense]() {
        didSet {
            updateNeededSum(with: updateTotalSum())

            if expenses.isEmpty {
                emptyView.isHidden = false
            } else {
                emptyView.isHidden = true
            }
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadExpenses()
    }
    
    // MARK: - Private methods
    
    private func updateTotalSum() -> Double {
        var totalSum: Double = 0.0
        for expense in expenses {
            if expense.done != true {
                totalSum += expense.amount
            }
        }
        
        totalSumLabel.text = "Total Sum: \(totalSum)"
        return totalSum
    }
    
    private func updateNeededSum(with totalSum: Double) {
        let currentSum = 100.0 // will count from расход/приход
        let neededSum = totalSum - currentSum
        neededSumLabel.text = neededSum > 0 ? "Needful Sum: \(neededSum)" : "Needful Sum: 0"
    }
    
    // MARK: - Actions
    
    @IBAction func touchNewExpense(_ sender: UIButton) {
        let controller : NewExpenseViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewExpenseVC") as! NewExpenseViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func touchMenuButton(_ sender: UIButton) {
        let controller : MenuPopupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuPopup") as! MenuPopupViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
        
        
    }
    
    // MARK: - ExpensesViewControllerDelegate
    
    func addNewExpenseTouched(newExpense: Expense) {
        expenses.append(newExpense)
        
        saveExpense()
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveExpense() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadExpenses(with request: NSFetchRequest<Expense> = Expense.fetchRequest()) {
        do {
            expenses = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension ExpensesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ExpenseCell
        cell.expenseNameLabel.text = "\(expenses[indexPath.row].name!)"
        cell.expenseAmountLabel.text = "\(expenses[indexPath.row].amount)"
        cell.accessoryType = expenses[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        context.delete(expenses[indexPath.row])
        expenses.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveExpense()
        
      }
    }
}

//MARK: - TableView Delegate Methods

extension ExpensesViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            expenses[indexPath.row].done = !expenses[indexPath.row].done

            saveExpense()
            updateNeededSum(with: updateTotalSum())
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
}

