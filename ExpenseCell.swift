//
//  ExpenseCell.swift
//  Expense
//
//  Created by Виктория Саклакова on 09.04.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {
    @IBOutlet weak var expenseNameLabel: UILabel!
    @IBOutlet weak var expenseAmountLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        expenseAmountLabel.textColor = nil
        backgroundColor = .white
    }
}
