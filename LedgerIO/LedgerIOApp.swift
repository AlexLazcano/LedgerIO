//
//  LedgerIOApp.swift
//  LedgerIO
//
//  Created by Alex Lazcano on 2023-12-25.
//

import SwiftUI
import SwiftData

@main
struct LedgerIOApp: App {
    
//    let container = try! ModelContainer(for: Expense.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//    for i in 1..<10 {
//        let expense = Expense(name: "test\(i)", date: .now, value: i)
//            container.mainContext.insert(expense)
//    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Expense.self, Friend.self])
    }
}
