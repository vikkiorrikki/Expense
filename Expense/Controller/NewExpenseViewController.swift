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
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    weak var delegate: ExpensesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessageLabel.isHidden = true
    }
    
    @IBAction func addNewExpenseTouched(_ sender: UIButton) {
        if !((expenseNameTextField.text)!.isEmpty) || !((expenseAmountTextField.text)!.isEmpty) {
            guard let name = expenseNameTextField.text, !name.isEmpty else {
                errorMessageLabel.isHidden = false
                errorMessageLabel.text! = "Name is empty. Please fill field."
                
                expenseNameTextField.layer.borderColor = #colorLiteral(red: 0.6643349528, green: 0, blue: 0.08385483176, alpha: 1)
                expenseNameTextField.layer.borderWidth = 1.0
                expenseAmountTextField.layer.borderWidth = 0.0
                return
            }
            guard let amountText = expenseAmountTextField.text, let amount = Double(amountText) else {
                errorMessageLabel.isHidden = false
                errorMessageLabel.text! = "Amount is empty. Please fill field."
                
                expenseAmountTextField.layer.borderColor = #colorLiteral(red: 0.6643349528, green: 0, blue: 0.08385483176, alpha: 1)
                expenseAmountTextField.layer.borderWidth = 1.0
                expenseNameTextField.layer.borderWidth = 0.0
                return
            }
            let newExpense = Expense(name: name, amount: amount)
            delegate?.addNewExpenseTouched(newExpense: newExpense)
            self.dismiss(animated: true, completion: nil)
        } else {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text! = "Fields are empty. Please fill fields."
            
            expenseNameTextField.layer.borderColor = #colorLiteral(red: 0.6643349528, green: 0, blue: 0.08385483176, alpha: 1)
            expenseNameTextField.layer.borderWidth = 1.0
            
            expenseAmountTextField.layer.borderColor = #colorLiteral(red: 0.6643349528, green: 0, blue: 0.08385483176, alpha: 1)
            expenseAmountTextField.layer.borderWidth = 1.0
        }
    }
}
