//
//  __SwiftData__App.swift
//  __SwiftData__
//
//  Created by  Sadi on 01/02/2025.
//

import SwiftUI
import SwiftData

@main
struct __SwiftData__App: App {
    
    let container : ModelContainer
    
    
    // Setting up different storage folder for storing data
//    init() {
//        let config = ModelConfiguration(url: URL.documentsDirectory.appending(path: "MyApp.store")) ///Making different store for storing data into the document directory
//        
//        do {
//            container = try ModelContainer(for: Book.self, configurations: config)
//        } catch {
//            fatalError("Could not configure the container")
//        }
//    }
    
    
    init() {
        let schema = Schema([Book.self])
        
        let config = ModelConfiguration("MyBook", schema: schema) //Setting a name of the sqlite file 
        
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //.modelContainer(for: Book.self) /// this is for storing data into a specific location given into the app (Application support directory)
        
        .modelContainer(container) /// this is for storing into different model container
    }
}
