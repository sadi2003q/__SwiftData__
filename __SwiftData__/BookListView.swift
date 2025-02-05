//
//  BookListView.swift
//  __SwiftData__
//
//  Created by  Sadi on 01/02/2025.
//

import SwiftUI
import SwiftData


struct BookListView: View {
    
    @State private var createNewBook: Bool = false
    
    @Environment(\.modelContext) private var context
    @Query(sort: \Book.title) private var books: [Book]
    
    
    var body: some View {
        NavigationStack{
            View_BookList
                .navigationTitle("Book List")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button_AddNewBook
                    }
                }
        }
        
        .sheet(isPresented: $createNewBook) {
            NewBookView()
                .presentationDetents([.medium])
        }
    }
    
    private var View_BookList: some View {
        HStack(spacing: 20){
            
            if books.isEmpty {
                ContentUnavailableView("Enter your first Book", systemImage: "book.fill")
            } else {
                List {
                    ForEach(books) { book in
                        NavigationLink {
                            EditView(book: book)
                        } label: {
                            HStack(spacing: 10) {
                                book.icon
                                VStack(alignment: .leading) {
                                    Text(book.title).font(.title2)
                                    Text(book.author).foregroundStyle(.secondary)
                                    if let rating = book.rating {
                                        HStack {
                                            ForEach(1..<rating, id: \.self) { _ in
                                                Image(systemName: "star.fill")
                                                    .imageScale(.small)
                                                    .foregroundStyle(.yellow)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let book = books[index]
                            context.delete(book)
                        }
                    }
                }
                .listStyle(.plain)
            }
            
            
        }
    }
    
    private func onDelete(_ indexSet: IndexSet) {
        context.delete(books[indexSet.first!])
    }
    
    private var Button_AddNewBook: some View {
        Button {
            createNewBook.toggle()
        } label: {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
        }
        
    }
}



#Preview {
    
    var showOnce = true
    
    NavigationStack {
        BookListView()
            .modelContainer(for: Book.self) { result in
                if showOnce {
                    switch result {
                    case .success(let container):
                        // Insert mock data into the container
                        let context = container.mainContext
                        let book1 = Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald")
                        let book2 = Book(title: "To Kill a Mockingbird", author: "Harper Lee")
                        let book3 = Book(title: "1984", author: "George Orwell")
                        
                        context.insert(book1)
                        context.insert(book2)
                        context.insert(book3)
                        
                    case .failure(let error):
                        print("Failed to create container: \(error.localizedDescription)")
                    }
                }
                
            }
            .onAppear{
                showOnce.toggle()
            }
    }
}
 
 
