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
    @IBOutlet weak var menuButton: UIButton!
    
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
        passDataToHistoryTab()
        
        menuButton.layer.cornerRadius = 15
        menuButton.clipsToBounds = true
    }
    
    // MARK: - Private methods
    
    private func updateTotalSum() -> Double {
        var totalSum = 0.0
        for goal in goals {
            if goal.done != true {
                totalSum += goal.amount
            }
        }
        totalSum = Double(round(100 * totalSum) / 100)
        totalSumLabel.text = "Total Sum: \(totalSum)"
        return totalSum
    }

    private func updateCurrentSum() -> Double {
        var currentSum = 0.0
        for record in records {
            currentSum += record.amount
        }
        currentSum = Double(round(100 * currentSum) / 100)
        currentSumLabel.text = currentSum > 0 ? "Current Sum: \(currentSum)" : "Current Sum: 0"
        return currentSum
    }
    
    private func updateNeededSum(with totalSum: Double, currentSum: Double) {
        var neededSum = totalSum - currentSum
        neededSum = Double(round(100 * neededSum) / 100)
        neededSumLabel.text = neededSum > 0 ? "Needed Sum: \(neededSum)" : "Needed Sum: 0"
    }
    
    private func passDataToHistoryTab() {
        let navController = self.tabBarController?.viewControllers?[1] as! UINavigationController
        let secondTab = navController.topViewController as! RecordsTableViewController
        secondTab.records = records
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
        saveToContext()
    }

    func addNewIncomeTouched(newIncome: Record){
        records.append(newIncome)
        saveToContext()
        passDataToHistoryTab()
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
        let doneSortDescriptor = NSSortDescriptor(key: "done", ascending: true)
        request.sortDescriptors = [doneSortDescriptor]
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
        let alert = UIAlertController(title: "Are you sure you want to remove item?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.context.delete(self.goals[indexPath.row])
            self.goals.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .left)
            self.saveToContext()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
      }
    }
    
}

//MARK: - TableView Delegate Methods

extension ExpensesViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if goals[indexPath.row].done == false {
                if updateCurrentSum() >= goals[indexPath.row].amount {
                    
                    goals[indexPath.row].done = true
                    
                    let record = Record(context: context)
                    record.amount = -(goals[indexPath.row].amount)
                    record.sign = false
                    record.id = goals[indexPath.row].id
                    record.name = goals[indexPath.row].name
                     
                    records.append(record)
                } else {
                    let alert = UIAlertController(title: "Current Summa should be more than Goal Amount", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            } else {
                goals[indexPath.row].done = false
                
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
            loadGoals()
            passDataToHistoryTab()
            updateNeededSum(with: updateTotalSum(), currentSum: updateCurrentSum())
            tableView.deselectRow(at: indexPath, animated: true)
        }
}

