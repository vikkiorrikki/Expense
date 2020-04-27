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
    var incomes = [Income]() {
        didSet {
            updateNeededSum(with: updateTotalSum(), currentSum: updateCurrentSum())
        }
    }
    var expenses = [Expense]() {
        didSet {
            updateNeededSum(with: updateTotalSum(), currentSum: updateCurrentSum())

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
        loadIncomes()
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

    private func updateCurrentSum() -> Double {
        var currentSum: Double = 0.0
        for income in incomes {
            currentSum += income.amount
        }
        currentSumLabel.text = currentSum > 0 ? "Current Sum: \(currentSum)" : "Current Sum: 0"
        return currentSum
    }
    
    private func updateNeededSum(with totalSum: Double, currentSum: Double) {
        let neededSum = totalSum - currentSum
        neededSumLabel.text = neededSum > 0 ? "Needful Sum: \(neededSum)" : "Needful Sum: 0"
    }

    // MARK: - Actions
    
    @IBAction func touchMenuButton(_ sender: UIButton) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuPopupVC") as! MenuPopupViewController
        controller.delegate = self
        present(controller, animated: true)

    }
    
    // MARK: - ExpensesViewControllerDelegate
    
    func addNewExpenseTouched(newExpense: Expense) {
        expenses.append(newExpense)
        print("addNewExpenseTouched")
        saveToContext()
    }
    
    func addNewIncomeTouched(){
        var textField = UITextField()
            
            let alert = UIAlertController(title: "Add new Income", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Income", style: .default) { (action) in
                //what will happen once the user clicks the Add Doctor button on UIAlert
                if let newIncomeText = textField.text, let newIncome = Double(newIncomeText) {
                    let income = Income(context: self.context)
                    income.amount = newIncome
                    income.id = UUID()
                    self.incomes.append(income)
                    self.saveToContext()
                    self.tableView.reloadData()
                } else {
                    //how to do when nothing happens by clicking on button
                }
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new Income"
                textField = alertTextField
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    
    //MARK: - Data Manipulation Methods
    
    func saveToContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
        print("savedToContext")
    }
    
    func loadExpenses(with request: NSFetchRequest<Expense> = Expense.fetchRequest()) {
        do {
            expenses = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        print("loadExpenses")
    }

    func loadIncomes(with request: NSFetchRequest<Income> = Income.fetchRequest()) {
            do {
                incomes = try context.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
            tableView.reloadData()
            print("loadIncomes")
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
//        expenses[indexPath.row].removed = true
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveToContext()
      }
    }
}

//MARK: - TableView Delegate Methods

extension ExpensesViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            expenses[indexPath.row].done = !expenses[indexPath.row].done
   
            
            if expenses[indexPath.row].done {
                let income = Income(context: context)
                income.amount = -(expenses[indexPath.row].amount)
                income.sign = false
                income.id = expenses[indexPath.row].id
                incomes.append(income)
            } else {
                var i = 0
                while i < incomes.count {
                    if expenses[indexPath.row].id == incomes[i].id {
                        context.delete(incomes[i])
                        incomes.remove(at: i)
                    }
                    i += 1
                }
            }
            
            saveToContext()
            updateNeededSum(with: updateTotalSum(), currentSum: updateCurrentSum())
            tableView.deselectRow(at: indexPath, animated: true)
        }
}

