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
    var records = [Record]() {
        didSet {
            updateNeededSum(with: updateTotalSum(), currentSum: updateCurrentSum())
        }
    }
    var goals = [Goal]() {
        didSet {
            updateNeededSum(with: updateTotalSum(), currentSum: updateCurrentSum())

            if goals.isEmpty {
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
        loadGoals()
        loadRecords()
    }
    
    // MARK: - Private methods
    
    private func updateTotalSum() -> Double {
        var totalSum: Double = 0.0
        for goal in goals {
            if goal.done != true {
                totalSum += goal.amount
            }
        }
        totalSumLabel.text = "Total Sum: \(totalSum)"
        return totalSum
    }

    private func updateCurrentSum() -> Double {
        var currentSum: Double = 0.0
        for record in records {
            currentSum += record.amount
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
    
    func addNewGoalTouched(newGoal: Goal) {
        goals.append(newGoal)
        print("addNewGoalTouched")
        saveToContext()
    }

    func addNewIncomeTouched(newIncome: Record){
        records.append(newIncome)
        print("addNewIncomeTouched")
        saveToContext()
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
    
    func loadGoals(with request: NSFetchRequest<Goal> = Goal.fetchRequest()) {
        do {
            goals = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        print("loadGoals")
    }

    func loadRecords(with request: NSFetchRequest<Record> = Record.fetchRequest()) {
            do {
                records = try context.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
            tableView.reloadData()
            print("loadRecords")
        }
}

//MARK: - UITableViewDataSource

extension ExpensesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ExpenseCell
        cell.expenseNameLabel.text = "\(goals[indexPath.row].name!)"
        cell.expenseAmountLabel.text = "\(goals[indexPath.row].amount)"
        cell.accessoryType = goals[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        context.delete(goals[indexPath.row])
        goals.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveToContext()
      }
    }
}

//MARK: - TableView Delegate Methods

extension ExpensesViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            goals[indexPath.row].done = !goals[indexPath.row].done
   
            
            if goals[indexPath.row].done {
                let expense = Record(context: context)
                expense.amount = -(goals[indexPath.row].amount)
                expense.sign = false
                expense.id = goals[indexPath.row].id
                expense.name = goals[indexPath.row].name
                records.append(expense)
            } else {
                var i = 0
                while i < records.count {
                    if goals[indexPath.row].id == records[i].id {
                        context.delete(records[i])
                        records.remove(at: i)
                    }
                    i += 1
                }
            }
            
            saveToContext()
            updateNeededSum(with: updateTotalSum(), currentSum: updateCurrentSum())
            tableView.deselectRow(at: indexPath, animated: true)
        }
}

