//
//  MenuPopupViewController.swift
//  Expense
//
//  Created by Виктория Саклакова on 12.04.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class MenuPopupViewController: UIViewController {

    weak var delegate: ExpensesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func newExpenseButtonTouched(_ sender: UIButton) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewExpenseVC") as! NewExpenseViewController
            controller.delegate = delegate
        self.dismiss(animated: false)
        delegate?.navigationController?.pushViewController(controller, animated: true) 
        
    }
    
    @IBAction func newIncomeButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: false)
        delegate?.addNewIncomeTouched()
    }
    
    @IBAction func touchedDismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
