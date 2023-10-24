//
//  ContentView.swift
//  Todo
//
//  Created by Mohammad Azam on 10/23/23.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: []) private var todoItems: FetchedResults<TodoItem>
    
    @State private var title: String = ""
    
    private enum ItemStatus {
        case pending
        case completed
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    private var pendingTaskItems: [TodoItem] {
        todoItems.filter { $0.isCompleted == false }
    }
    
    private var completedTaskItems: [TodoItem] {
        todoItems.filter { $0.isCompleted == true }
    }
    
    private func saveTodoItem() {
        let todoItem = TodoItem(context: context)
        todoItem.title = title
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateTodoItem(_ todoItem: TodoItem) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func deleteTodoItem(_ todoItem: TodoItem) {
        
        context.delete(todoItem)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    if isFormValid {
                        saveTodoItem()
                        // clear
                        title = ""
                    }
                }
            
            List {
                Section("Pending") {
                    if pendingTaskItems.isEmpty {
                        ContentUnavailableView("No items found.", systemImage: "doc")
                    } else {
                        ForEach(pendingTaskItems) { todoItem in
                            TodoCellView(todoItem: todoItem, onChanged: updateTodoItem)
                        }.onDelete(perform: { indexSet in
                            // delete the item from pendingTaskItems
                            indexSet.forEach { index in
                                let todoItem = pendingTaskItems[index]
                                deleteTodoItem(todoItem)
                            }
                        })
                    }
                }
               
                Section("Completed") {
                    if completedTaskItems.isEmpty {
                        ContentUnavailableView("No items found.", systemImage: "doc")
                    } else {
                        ForEach(completedTaskItems) { todoItem in
                            TodoCellView(todoItem: todoItem, onChanged: updateTodoItem)
                        }.onDelete(perform: { indexSet in
                            // delete the item from pendingTaskItems
                            indexSet.forEach { index in
                                let todoItem = completedTaskItems[index]
                                deleteTodoItem(todoItem)
                            }
                        })
                    }
                }
            }
             
            Spacer()
        }
        .padding()
        .navigationTitle("Todo")
    }
}

struct TodoCellView: View {
    
    let todoItem: TodoItem
    let onChanged: (TodoItem) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: todoItem.isCompleted ? "checkmark.square": "square")
                .onTapGesture {
                    todoItem.isCompleted = !todoItem.isCompleted
                    onChanged(todoItem)
                }
            if todoItem.isCompleted {
                Text(todoItem.title ?? "")
            } else {
                TextField("", text: Binding(get: {
                    todoItem.title ?? ""
                }, set: { newValue in
                    todoItem.title = newValue
                })).onSubmit {
                    onChanged(todoItem)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
    }
}
