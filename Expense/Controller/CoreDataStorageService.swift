//
//  CoreDataStorageService.swift
//  Expense
//
//  Created by Виктория Саклакова on 05.05.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStorageService {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveToContext(tableView: UITableView) {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
//        print("savedToContext")
    }
    
    func loadGoals(with request: NSFetchRequest<Goal> = Goal.fetchRequest(), goals: [Goal], tableView: UITableView) -> [Goal] {
        var loadedGoals = goals
        let doneSortDescriptor = NSSortDescriptor(key: "done", ascending: true)
        request.sortDescriptors = [doneSortDescriptor]
        do {
            loadedGoals = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }

        tableView.reloadData()
//        print("loadGoals")
        
        return loadedGoals
    }

    func loadRecords(with request: NSFetchRequest<Record> = Record.fetchRequest(), records: [Record], tableView: UITableView) -> [Record] {
        var loadedRecords = records
        do {
            loadedRecords = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
//        print("loadRecords")
        
        return loadedRecords
    }
}
