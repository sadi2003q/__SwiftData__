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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
