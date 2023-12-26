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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Expense.self])
    }
}
