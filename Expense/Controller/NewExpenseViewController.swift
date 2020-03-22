//
//  NewExpenseViewController.swift
//  Expense
//
//  Created by Виктория Саклакова on 19.03.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class NewExpenseViewController: UIViewController {

    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseAmountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var delegate: ExpensesViewController?
    
    @IBAction func addNewExpenseTouched(_ sender: UIButton) {
        if let name = expenseNameTextField.text, let amountText = expenseAmountTextField.text, let amount = Double(amountText){
            let newExpense = Expense(name: name, count: amount)
            delegate?.addNewExpenseTouched(newExpense: newExpense)
        }
        self.dismiss(animated: true, completion: nil)
    }
}