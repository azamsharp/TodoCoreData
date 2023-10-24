//
//  TodoApp.swift
//  Todo
//
//  Created by Mohammad Azam on 10/23/23.
//

import SwiftUI

@main
struct TodoApp: App {
    
    let provider = CoreDataProvider()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environment(\.managedObjectContext, provider.viewContext)
            }
        }
    }
}
