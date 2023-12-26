//
//  Expense.swift
//  LedgerIO
//
//  Created by Alex Lazcano on 2023-12-25.
//

import Foundation
import SwiftData

@Model
class Expense {
    var name: String
    var date: Date
    var value: Double
    init(name: String, date: Date, value: Double = 0) {
        self.name = name
        self.date = date
        self.value = value
    }
}
