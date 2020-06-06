//
//  RecordsTableViewController.swift
//  Expense
//
//  Created by Виктория Саклакова on 28.04.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit
import CoreData

class RecordsTableViewController: UITableViewController {

    @IBOutlet weak var recordsTableView: UITableView!
    var records = [Record]() {
        didSet {
            tableView.reloadData()
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 600
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordsTableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! ExpenseCell
        cell.expenseNameLabel.text = "\(records[indexPath.row].name!)"
        
        let amount = records[indexPath.row].amount
        let roundedAmount = String(format: "%.0f", amount)
        cell.expenseAmountLabel.text = "\(roundedAmount)"
    
        if amount > 0 {
            cell.expenseAmountLabel.textColor = #colorLiteral(red: 0.1444485188, green: 0.2778060734, blue: 0.2674380839, alpha: 1)
        } else {
            cell.expenseAmountLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        
        return cell
    }
}
