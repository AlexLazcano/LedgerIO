//
//  ContentView.swift
//  LedgerIO
//
//  Created by Alex Lazcano on 2023-12-25.
//

import SwiftUI
import SwiftData

struct ExpenseView: View {
    @State private var isShowingAddSheet = false
    @Environment(\.modelContext) private var context
    @Query(sort: \Expense.date) var expenses: [Expense]
    
    func getTotal(_ expneses: [Expense]) -> Double {
        expneses.reduce(0) {sum, e in
            sum + e.value
        }
    }
    
    
    
    var body: some View {
        NavigationStack {
            Text("Total: \(getTotal(expenses), format: .currency(code: "CAD"))")
            List {
                ForEach(expenses) { expense in
                    ExpenseCell(expense: expense)
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        context.delete(expenses[index])
                    }
                })
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
    return ExpenseView()
}

struct ExpenseCell: View {
    let expense: Expense
    var body: some View {
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            VStack {
                Text(expense.name)
                Text(expense.value, format: .currency(code: "CAD"))
                
            }
            
            
            Spacer()
            
            Text(expense.participant.name)
        }
    }
}

enum SplitOption: String, CaseIterable, Identifiable {
    case even, percentage, manual
    var id: Self { self }
}


struct AddExpenseSheet: View {
    @Query(sort: \Friend.name) var friends: [Friend]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var totalValue: Double = 0
    @State private var paidBy: Friend?
    @State private var splitOption: SplitOption = .even
    @State private var percentage: Double = 0.5
    @State private var amountLent: Double = 0
    @State private var participants: [Friend] = []
    
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Paid By", selection: $paidBy) {
                    ForEach(friends) { participant in
                        Text(participant.name)
                            .tag(participant as Friend?)
                    }
                }
                .pickerStyle(.menu)
                
                                
                TextField("Expense Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value:$totalValue, format:.currency(code: "CAD"))
                    .keyboardType(.decimalPad)
                
                
                Picker("Spit", selection: $splitOption) {
                    ForEach(SplitOption.allCases) { option in
                        Text(option.rawValue.capitalized)
                    }
                    
                }
                .pickerStyle(.segmented)
                
                switch(splitOption) {
                case .percentage:
                    VStack {
                        TextField("Split", value: $percentage, format: .number).keyboardType(.decimalPad)
                        Slider(value: $percentage, in: 0...1, step: 0.01)
                    }
                case .even:
                    Text("Even")
                    
                    
                case .manual:
                    Text("Manual")
                }
                
                HStack {
                
                    
                    Text(totalValue*percentage, format: .currency(code: "CAD"))
                    Text(totalValue*(1-percentage), format: .currency(code: "CAD"))
                }
                
                
                
                
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
                        print("creating", name, date, totalValue)
                        guard let participant = paidBy else {
                            print("Participant is nil. Cannot create expense.")
                            return
                        }
                        
                        
                        let expense = Expense(name: name, date: date, value: totalValue, participant: participant)
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


