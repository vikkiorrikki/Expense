//
//  MenuPopupViewController.swift
//  Expense
//
//  Created by Виктория Саклакова on 12.04.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class MenuPopupViewController: UIViewController {

    weak var delegate: ExpensesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func newExpenseButtonTouched(_ sender: UIButton) {
            let controller : NewExpenseViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewExpenseVC") as! NewExpenseViewController
            controller.delegate = delegate

            navigationController?.pushViewController(controller, animated: true)
        }

}
