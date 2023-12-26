//
//  ContentView.swift
//  LedgerIO
//
//  Created by Alex Lazcano on 2023-12-25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
   
    
    
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: ExpenseView()) {
                Text("Expenses")
            }
            
            NavigationLink(destination: FriendsView())  {
                Text("Friends")
            }
            .navigationTitle("Home")
        }

    }
}

#Preview {
    ContentView()
}
