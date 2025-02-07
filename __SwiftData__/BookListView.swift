//
//  BookListView.swift
//  __SwiftData__
//
//  Created by  Sadi on 07/02/2025.
//

import SwiftUI
import SwiftData


struct BookListView: View {
    
    @Query(sort: \Book.title) private var books: [Book]
    @Environment(\.modelContext) private var context
    
    @State private var showAddView = false
    
    
    var body: some View {
        View_content
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button_addNewBook
                }
            }
            .sheet(isPresented: $showAddView) {
                AddView()
                    .presentationDetents([.medium])
            }
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
    
    private var View_EmptyView: some View {
        ContentUnavailableView("Enter your first book.", systemImage: "book.fill")
    }
    
    private var Button_addNewBook: some View {
        Button {
            showAddView.toggle()
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let book = books[index]
            context.delete(book)
        }
    }
    
    
    
    
}

private struct BookItemView: View {
    @Bindable var book: Book
    @State private var rating: Int?
    
//    init(book: Book) {
//        self.book = book
//        self._rating = State(initialValue: book.rating) // Initialise rating
//    }
    
    var body: some View {
        HStack {
            book.icon
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                    .foregroundStyle(.secondary)
                
                if book.rating != -1 {
                    RatingsView(maxRating: 5, currentRating: $book.rating)
                }
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        BookListView()
    }
    .modelContainer(for: Book.self)
    
}
