//
//  ContentView.swift
//  __SwiftData__
//
//  Created by  Sadi on 01/02/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            BookListView()
        }
    }
}

#Preview {
    
    let preview = Preview(Book.self)
    preview.addExamples(Book.sampleBooks)
    
    return NavigationStack {
        ContentView()
           
    }
    .modelContainer(preview.container)
    
    
}
