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
                            Text(book.title)
                        } label: {
                            HStack(spacing: 20) {
                                book.icon
                                VStack(alignment: .leading) {
                                    Text(book.title).font(.title2)
                                    Text(book.author).foregroundStyle(.secondary)
                                    
                                    if let rating = book.rating {
                                        ForEach(0..<rating, id: \.self) { _ in
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
            }
            
            
        }
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
    BookListView()
    /// will store in memory but not permanent. it will remove all data as soon as the app is closed
    ///`````
    ///.modelContainer(for: Book.self, inMemory: true)
    ///```
    ///
       /// this will store the data on the disk, so the data will be maintained even after app is closed
        .modelContainer(for: Book.self)
}
