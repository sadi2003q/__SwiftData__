//
//  BookList.swift
//  __SwiftData__
//
//  Created by  Sadi on 09/02/2025.
//

import SwiftUI
import SwiftData


struct BookList: View {
    
    @Environment(\.modelContext) private var context
    @Query private var books: [Book]
    
    init(sortOrder : SortOder) {
        let sortDescriptor: [SortDescriptor<Book>] =
        switch sortOrder {
        case .status:
            [SortDescriptor(\Book.status), SortDescriptor(\Book.title)]
        case .author:
            [SortDescriptor(\Book.author)]
        case .title:
            [SortDescriptor(\Book.title)]
        }
        _books = Query(sort: sortDescriptor)
    }
    
    var body: some View {
        View_content
    }
    
    
    
    
    private var View_content: some View {
        Group {
            if books.isEmpty {
                View_EmptyView
            } else {
                
                View_bookItem
            }
        }
    }
    
    
    private var View_EmptyView: some View {
        ContentUnavailableView("Enter your first book.", systemImage: "book.fill")
    }
    
    private var View_bookItem: some View {
        List {
            ForEach(books) { book in
                NavigationLink {
                    EditView(book: book)
                } label: {
                    BookItemView(book: book)
                }

                
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let book = books[index]
            context.delete(book)
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    preview.addExamples(Book.sampleBooks)
    return NavigationStack {
        BookList(sortOrder: .title)
    }
    .modelContainer(preview.container)
}
