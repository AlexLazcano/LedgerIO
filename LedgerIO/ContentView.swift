//
//  ContentView.swift
//  LedgerIO
//
//  Created by Alex Lazcano on 2023-12-25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isShowingAddSheet = false
    
    @Query(sort: \Expense.date) var expenses: [Expense]
    
    func getTotal(_ expneses: [Expense]) -> Double {
        expneses.reduce(0) {sum, e in
            sum + e.value
        }
    }
    
    
    
    var body: some View {
        NavigationStack {
            Text("Total: \(getTotal(expenses))")
            List {
                ForEach(expenses) { expense in
                    ExpenseCell(expense: expense)
                }
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingAddSheet) {
                AddExpenseSheet()
            }
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add Expense") {
                        isShowingAddSheet = true
                    }
                }
            }
            .overlay {
                if expenses.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Expenses", systemImage: "nosign")
                    }, description: {
                        Text("Start by adding")
                    }, actions: {
                        Button("Add Expnese") {
                            isShowingAddSheet = true
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct ExpenseCell: View {
    let expense: Expense
    var body: some View {
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(expense.value, format: .currency(code: "CAD"))
        }
    }
}

struct AddExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value:$value, format:.currency(code: "CAD")).keyboardType(.decimalPad)
                
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { 
                        dismiss() }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        print("creating", name, date, value)
                        let expense = Expense(name: name, date: date, value: value)
                        print("created expense")
                        context.insert(expense)
                        print("inserted")
                        dismiss()
                    }
                }
            }
        }
    }
}

