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
                VStack(alignment: .leading) {
                    Text(expense.date, format: .dateTime.month(.abbreviated).day())
                        .frame(width: 70, alignment: .leading)
                    Text(expense.paidBy.name)
                    Text("Paid \(expense.value, format: .currency(code: "CAD"))")
                    
                }
                Spacer()
                if true  {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title)
                } else {
                    Image(systemName: "multiply.square.fill")
                        .foregroundColor(.red)
                        .font(.title)
                }
                
                Spacer()
                VStack(alignment: .trailing) {
                    Text(expense.name)
                    Text(expense.bowrrower.name)
                    Text("Owes \(expense.amountLent, format: .currency(code: "CAD"))")
                    
                }
            }
    }
}

enum SplitOption: String, CaseIterable, Identifiable {
    case even, percentage, manual
    var id: Self { self }
}


struct AddExpenseSheet: View {
    @Query(sort: \User.name) var people: [User]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var totalValue: Double = 0
    @State private var paidBy: User?
    @State private var splitOption: SplitOption = .even
    @State private var percentage: Double = 0.5
    @State private var borrower: User?
    @State private var amountLent: Double = 0
    
    func splitEven()  {
        amountLent = totalValue * 0.5
        percentage = 0.5
    }
    
    func splitPercent() {
        amountLent = (1-percentage) * totalValue
    }
    
    func splitManual(amount: Double){
        amountLent = amount
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Paid By", selection: $paidBy) {
                    ForEach(people) { person in
                        Text(person.name)
                            .tag(person as User?)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Borrower", selection: $borrower) {
                    ForEach(people) { person in
                        Text(person.name)
                            .tag(person as User?)
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
                
                .onChange(of: splitOption, initial: true) { _, newValue in
                    switch(newValue) {
                        
                    case .even:
                        splitEven()
                    case .percentage:
                        splitPercent()
                    case .manual:
                        splitManual(amount: 10)
                    }
                    
                }
                switch(splitOption) {
                case .percentage:
                    VStack {
                        TextField("Split", value: $percentage, format: .number).keyboardType(.decimalPad)
                        Slider(value: $percentage, in: 0...1, step: 0.01)
                            .onChange(of: percentage) {
                                splitPercent()
                            }
                    }
                case .even:
                    Text("Even")
                case .manual:
                    Text("Manual")
                }
                
                
                
                
                
                HStack {
                    VStack{
                        Text("\(paidBy?.name ?? "Person 1") Paid")
                        Text(totalValue-amountLent, format: .currency(code: "CAD"))
                    }
                    
                    Spacer()
                    VStack {
                        Text("\(borrower?.name ?? "Person 2") Borrowed")
                        Text(amountLent, format: .currency(code: "CAD"))
                        
                    }
                    
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
                        guard let paidBy = paidBy else {
                            print("paidBy is nil. Cannot create expense.")
                            return
                        }
                        guard let borrower = borrower else {
                            print("Borrower is nil. Cannot create expense.")
                            return
                        }
                        
                        
                        let expense = Expense(name: name, date: date, value: totalValue,
                                              paidBy: paidBy, borrower: borrower, amountLent: amountLent)
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


