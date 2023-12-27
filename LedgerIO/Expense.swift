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
    var paidBy: User
    var bowrrower: User
    var amountLent: Double
    init(name: String, date: Date, value: Double = 0, paidBy: User, borrower: User, amountLent: Double) {
        self.name = name
        self.date = date
        self.value = value
        self.paidBy = paidBy
        self.bowrrower = borrower
        self.amountLent = amountLent
    }
}
