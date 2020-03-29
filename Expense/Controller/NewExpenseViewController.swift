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
        guard !((expenseNameTextField.text)!.isEmpty) || !((expenseAmountTextField.text)!.isEmpty) else {
            setErrorMessageForLabel(label: errorMessageLabel, isHidden: false, errorMessage: "Fields are empty. Please fill fields.")
            setColorBorderForTextField(textField: expenseNameTextField, color: #colorLiteral(red: 0.6643349528, green: 0, blue: 0.08385483176, alpha: 1), borderWidth: 1.0)
            setColorBorderForTextField(textField: expenseAmountTextField, color: #colorLiteral(red: 0.6643349528, green: 0, blue: 0.08385483176, alpha: 1), borderWidth: 1.0)
            
            return
        }
        
        guard let name = expenseNameTextField.text, !name.isEmpty else {
            setErrorMessageForLabel(label: errorMessageLabel, isHidden: false, errorMessage: "Name is empty. Please fill field.")
            setColorBorderForTextField(textField: expenseNameTextField, color: #colorLiteral(red: 0.6643349528, green: 0, blue: 0.08385483176, alpha: 1), borderWidth: 1.0)
            setColorBorderForTextField(textField: expenseAmountTextField, color: UIColor.clear.cgColor, borderWidth: 0.0)
            
            return
        }
        
        guard let amountText = expenseAmountTextField.text, let amount = Double(amountText) else {
            setErrorMessageForLabel(label: errorMessageLabel, isHidden: false, errorMessage: "Amount is empty. Please fill field.")
            setColorBorderForTextField(textField: expenseAmountTextField, color: #colorLiteral(red: 0.6643349528, green: 0, blue: 0.08385483176, alpha: 1), borderWidth: 1.0)
            setColorBorderForTextField(textField: expenseNameTextField, color: UIColor.clear.cgColor, borderWidth: 0.0)
            
            return
        }
        
        let newExpense = Expense(name: name, amount: amount)
        delegate?.addNewExpenseTouched(newExpense: newExpense)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setColorBorderForTextField(textField: UITextField, color: CGColor, borderWidth: CGFloat) {
        textField.layer.borderColor = color
        textField.layer.borderWidth = borderWidth
    }
    
    func setErrorMessageForLabel(label: UILabel, isHidden: Bool, errorMessage: String) {
        label.isHidden = isHidden
        label.text! = errorMessage
    }
}
