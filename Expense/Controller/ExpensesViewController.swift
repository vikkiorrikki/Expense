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
        tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.restore()

        expenses = storageService.loadExpenses()
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
        if expenses.count == 0{
            tableView.setEmptyView(title: "You don't have any expenses.", message: "Your expenses will be in here.")
        } else {
            tableView.restore()
        }
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

//MARK: - UITableView

extension UITableView { //can we move it to separate file?
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false //??
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        //what is anchor
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0 //??
        messageLabel.textAlignment = .center
        
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none //??
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine //??
    }
}

