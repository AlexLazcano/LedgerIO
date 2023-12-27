//
//  FriendsView.swift
//  LedgerIO
//
//  Created by Alex Lazcano on 2023-12-26.
//

import SwiftUI
import SwiftData

struct FriendsView: View {
//    @State private var isShowingAddSheet = false
    @Environment(\.modelContext) private var context
    @State private var newFriend :String = ""
    @Query(sort: \User.name) var friends: [User]
    @State private var selectedFriend: String = "None"
    
    
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    if friends.isEmpty {
                        ContentUnavailableView(label: {
                            Label("No Friends", systemImage: "nosign")
                        }, description: {
                            Text("Start by adding")
                        }, actions: {
                            
                        })
                    }
                    ForEach(friends) { friend in
                        Text(friend.name)
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            context.delete(friends[index])
                        }
                    })
                    
                }
                
                Section {
                    TextField("Add New", text: $newFriend)
                    Button("Add") {
                        if newFriend == "" {
                            return
                        }
                        
                        let friend = User(name: newFriend)
                        context.insert(friend)
                        newFriend = ""
                    }
                }
                
                
            }
            .navigationTitle("People")
        }
    }
}

#Preview {
    FriendsView()
}
