//
//  ContentView.swift
//  todoList
//
//  Created by 심연아 on 1/19/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ToDo.isCompleted) private var toDos: [ToDo]
    
    @State private var isAlertShowing = false
    @State private var toDoTitle = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(toDos) { toDo in
                    HStack {
                        Button {
                            toDo.isCompleted.toggle()
                        } label: {
                            Image(systemName: toDo.isCompleted ? "checkmark.circle.fill" : "circle")
                        }
                        
                        Text(toDo.title)
                    }
                }
                .onDelete(perform: deleteToDos)
            }
            .navigationTitle("To do App")
            .toolbar {
                Button {
                    isAlertShowing.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .alert("Add To Do", isPresented: $isAlertShowing) {
                TextField("Enter ToDo", text: $toDoTitle)
                
                Button{
                    modelContext.insert(ToDo(title: toDoTitle, isCompleted: false))
                    toDoTitle = ""
                } label: {
                    Text("Add")
                }
                
            }
            .overlay {
                if toDos.isEmpty {
                    ContentUnavailableView("Noting to do yet.", systemImage: "checkmark.circle.fill")
                }
            }
        }
    }
    
    func deleteToDos(_ indexSet: IndexSet) {
        for index in indexSet {
            let toDo = toDos[index]
            modelContext.delete(toDo)
        }
    }
}

#Preview {
    ContentView()
}
