//
//  NewBookView.swift
//  __SwiftData__
//
//  Created by  Sadi on 01/02/2025.
//

import SwiftUI

struct NewBookView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var author: String = ""
    
    var body: some View {
        NavigationStack {
            View_AddBook
                .navigationTitle("New Book")
                .navigationBarTitleDisplayMode(.inline)
                
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        
    }
    
    private var View_AddBook: some View {
        Form {
            TextField("Book Title", text: $title)
            TextField("Author", text: $author)
            
            HStack {
                Spacer()
                Button("create") {
                    let newBook = Book(title: title, author: author)
                    context.insert(newBook) 
                    dismiss()
                }
            }
            .disabled(title.isEmpty || author.isEmpty)
            .frame(width: .infinity, alignment: .trailing)
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
            
        }
        
    }
    
    
}

#Preview {
    NewBookView()
}
