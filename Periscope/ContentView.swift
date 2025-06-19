//
//  ContentView.swift
//  Periscope
//
//  Created by Roshan Nindrai on 6/14/25.
//

import SwiftUI
import SwiftData
import Lego

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [Item]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp.formatted(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp.formatted(date: .numeric, time: .standard))
                            .foregroundColor(.primary)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
