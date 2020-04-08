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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessageLabel.isHidden = true
    }
    
    @IBAction func addNewExpenseTouched(_ sender: UIButton) {
        guard let name = expenseNameTextField.text, let amountText = expenseAmountTextField.text
            else {
                return
        }
        
        if name.isEmpty && amountText.isEmpty {
//            // both empty
            setErrorMessageForLabel(with: "Fields are empty. Please fill fields.")
            setRedBorder(textField: expenseNameTextField)
            setRedBorder(textField: expenseAmountTextField)

        } else {
            if name.isEmpty {
                // error for name
                errorMessageLabel.text =  "Name is empty. Please fill field."
                setErrorMessageForLabel(with: "Name is empty. Please fill field.")
                setRedBorder(textField: expenseNameTextField)
                setNotBorder(textField: expenseAmountTextField)
                
            } else if amountText.isEmpty {
                // error for amount
                setErrorMessageForLabel(with: "Amount is empty. Please fill field.")
                setRedBorder(textField: expenseAmountTextField)
                setNotBorder(textField: expenseNameTextField)
                
            } else {
                if let amount = Double(amountText) {
                    let newExpense = Expense(context: context)
                    newExpense.name = name
                    newExpense.amount = amount
                    delegate?.addNewExpenseTouched(newExpense: newExpense)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    setErrorMessageForLabel(with: "Amount should be as double")
                    setRedBorder(textField: expenseAmountTextField)
                    setNotBorder(textField: expenseNameTextField)
                }
            }
        }
        
    }
    
    func setRedBorder(textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.6643349528, green: 0, blue: 0.08385483176, alpha: 1)
        textField.layer.borderWidth = 1.0
    }
    func setNotBorder(textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
    }
    func setErrorMessageForLabel(with errorMessage: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = errorMessage
    }
}
