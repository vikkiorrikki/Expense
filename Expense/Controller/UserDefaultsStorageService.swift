//
//  UserDefaultsStorageService.swift
//  Expense
//
//  Created by Виктория Саклакова on 23.03.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import Foundation

class UserDefaultsStorageService {
    
    let defaults = UserDefaults.standard
    let keyForUserDefaults = "savedExpenses"
    
    func saveExpenses(_ expenses: [Expense]) {
        print("encode \(expenses)")
        let expenses = try? PropertyListEncoder().encode(expenses)
        defaults.set(expenses, forKey: keyForUserDefaults)
    }
    
    func loadExpenses() -> [Expense] {
        if let data = defaults.value(forKey: keyForUserDefaults) {
            let expenses = try! PropertyListDecoder().decode([Expense].self, from: data as! Data)
            print("decode")
            return expenses
        } else {
            self.saveExpenses([])
            return []
        }
    }
}
