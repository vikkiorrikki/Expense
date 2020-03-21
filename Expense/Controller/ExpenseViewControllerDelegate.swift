//
//  ExpenseViewControllerDelegate.swift
//  Expense
//
//  Created by Виктория Саклакова on 21.03.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import Foundation

protocol ExpenseViewControllerDelegate {
    func addNewExpenseTouched (newExpense: Expense)
}
