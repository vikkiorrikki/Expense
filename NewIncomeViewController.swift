//
//  NewIncomeViewController.swift
//  Expense
//
//  Created by Виктория Саклакова on 28.04.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class NewIncomeViewController: UIViewController {

    @IBOutlet weak var incomeNameTextField: UITextField!
    @IBOutlet weak var incomeAmountTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    weak var delegate: ExpensesViewControllerDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessageLabel.isHidden = true
    }
    
    @IBAction func addNewIncomeTouched(_ sender: UIButton) {
        guard let amountText = incomeAmountTextField.text
            else {
                return
        }
        
        if amountText.isEmpty {
                // error for amount
                setErrorMessageForLabel(with: "Amount is empty. Please fill field.")
                setRedBorder(textField: incomeAmountTextField)
                setNotBorder(textField: incomeNameTextField)
                
            } else {
                if let amount = Double(amountText) {
                    if amount > 0 {
                        let newIncome = Record(context: context)
                        
                        if incomeNameTextField.text == "" {
                            newIncome.name = "Unnamed income"
                        } else {
                            newIncome.name = incomeNameTextField.text
                        }
                        
                        newIncome.amount = amount
                        newIncome.id = UUID()
                        delegate?.addNewIncomeTouched(newIncome: newIncome)
                        
                        navigationController?.popToRootViewController(animated: true)
                        
                    } else {
                        setErrorMessageForLabel(with: "Amount should be more than 0")
                        setRedBorder(textField: incomeAmountTextField)
                        setNotBorder(textField: incomeNameTextField)
                    }
                } else {
                    setErrorMessageForLabel(with: "Amount should be as double")
                    setRedBorder(textField: incomeAmountTextField)
                    setNotBorder(textField: incomeNameTextField)
                }
            }
        }
        
    func setRedBorder(textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
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
