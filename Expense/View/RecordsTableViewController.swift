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
    var records = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        recordsTableView.reloadData()
        print(records)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! ExpenseCell

        cell.expenseNameLabel.text = "\(records[indexPath.row].name!)"
        let amount = records[indexPath.row].amount
        if amount > 0 {
            cell.expenseAmountLabel.text = "\(records[indexPath.row].amount)"
        } else {
            cell.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            cell.expenseAmountLabel.text = "\(records[indexPath.row].amount)"
        }
        return cell
    }

}
