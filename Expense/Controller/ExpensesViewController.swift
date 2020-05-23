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
    let storageService = CoreDataStorageService()
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
        goals = storageService.loadGoals(goals: goals, tableView: tableView)
        records = storageService.loadRecords(records: records, tableView: tableView)
        passDataToHistoryTab()
        
        let plusImage = UIImage(systemName: "plus")
        let tintedImage = plusImage?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(tintedImage, for: .normal)
        menuButton.tintColor = .white
        menuButton.layer.cornerRadius = 25
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
        let roundedTotalSum = roundValue(totalSum)
        totalSumLabel.text = "\(roundedTotalSum) ₽"
        return totalSum
    }

    private func updateCurrentSum() -> Double {
        var currentSum = 0.0
        for record in records {
            currentSum += record.amount
        }
        let roundedCurrentSum = roundValue(currentSum)
        currentSumLabel.text = currentSum > 0 ? "\(roundedCurrentSum) ₽" : "0"
        return currentSum
    }
    
    private func updateNeededSum(with totalSum: Double, currentSum: Double) {
        let neededSum = totalSum - currentSum
        let roundedNeededSum = roundValue(neededSum)
        neededSumLabel.text = neededSum > 0 ? "\(roundedNeededSum) ₽" : "0"
    }
    
    func roundValue(_ value: Double) -> String {
        return String(format: "%.0f", value)
    }
    
    private func passDataToHistoryTab() {
        let navController = self.tabBarController?.viewControllers?[1] as! UINavigationController
        let secondTab = navController.topViewController as! RecordsTableViewController
        secondTab.records = records
    }

    // MARK: - Actions
    
    @IBAction func touchMenuButton(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
//        2
        let newGoalAction = UIAlertAction(title: "New goal", style: .default, handler: { (UIAlertAction) in
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewGoalVC") as! NewGoalViewController
                controller.delegate = self
            self.dismiss(animated: false)
            self.navigationController?.pushViewController(controller, animated: true)
        })
        
        
        let newIncomeAction = UIAlertAction(title: "New income", style: .default, handler: { (UIAlertAction) in
               let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewIncomeVC") as! NewIncomeViewController
               controller.delegate = self
               self.dismiss(animated: false)
            self.navigationController?.pushViewController(controller, animated: true)
        })
            
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
        // 4
        optionMenu.addAction(newGoalAction)
        optionMenu.addAction(newIncomeAction)
        optionMenu.addAction(cancelAction)
            
        // 5
        self.present(optionMenu, animated: true, completion: nil)
        
        
        
        
        
        
        
//        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuPopupVC") as! MenuPopupViewController
//        controller.delegate = self
//        present(controller, animated: true)
    }
    
    // MARK: - ExpensesViewControllerDelegate
    
    func addNewGoalTouched(newGoal: Goal) {
        goals.append(newGoal)
        storageService.saveToContext(tableView: tableView)
        goals = storageService.loadGoals(goals: goals, tableView: tableView)
    }

    func addNewIncomeTouched(newIncome: Record){
        records.append(newIncome)
        storageService.saveToContext(tableView: tableView)
        passDataToHistoryTab()
    }
    
}

//MARK: - UITableViewDataSource

extension ExpensesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ExpenseCell
        cell.expenseNameLabel.text = "\(goals[indexPath.section].name!)"
        
        let roundedAmount = roundValue(goals[indexPath.section].amount)
        cell.expenseAmountLabel.text = "\(roundedAmount) ₽"
        
        cell.accessoryType = goals[indexPath.section].done ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        let alert = UIAlertController(title: "Are you sure you want to remove item?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.context.delete(self.goals[indexPath.section])
            self.goals.remove(at: indexPath.section)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .automatic)
            
//            tableView.deleteRows(at: [indexPath], with: .left)
            self.storageService.saveToContext(tableView: tableView)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
      }
    }
    
}

//MARK: - TableView Delegate Methods

extension ExpensesViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if goals[indexPath.section].done == false {
                if updateCurrentSum() >= goals[indexPath.section].amount {
                    
                    goals[indexPath.section].done = true
                    
                    let record = Record(context: context)
                    record.amount = -(goals[indexPath.section].amount)
                    record.sign = false
                    record.id = goals[indexPath.section].id
                    record.name = goals[indexPath.section].name
                     
                    records.append(record)
                } else {
                    let alert = UIAlertController(title: "Current Summa should be more than Goal Amount", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            } else {
                goals[indexPath.section].done = false
                
                var i = 0
                while i < records.count {
                    if goals[indexPath.section].id == records[i].id {
                        context.delete(records[i])
                        records.remove(at: i)
                    }
                    i += 1
                }
            }
            storageService.saveToContext(tableView: tableView)
            goals = storageService.loadGoals(goals: goals, tableView: tableView)
            passDataToHistoryTab()
            updateNeededSum(with: updateTotalSum(), currentSum: updateCurrentSum())
            tableView.deselectRow(at: indexPath, animated: true)
        }
}

