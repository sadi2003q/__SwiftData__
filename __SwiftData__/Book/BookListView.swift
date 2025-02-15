//
//  BookListView.swift
//  __SwiftData__
//
//  Created by  Sadi on 07/02/2025.
//

import SwiftUI
import SwiftData

enum SortOder: String, Identifiable, CaseIterable {
    case title
    case author
    case status
    
    var id: Self {
        self
    }
    
}
struct BookListView: View {
    
    
    @State private var showAddView = false
    @State private var sortOrder: SortOder = .author
    
    var body: some View {
        
        VStack {
            Section_Filter
            BookList(sortOrder: sortOrder)
        }
        
        
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
    
    
    
    private var Section_Filter: some View {
        HStack {
            Text("Filter")
            Spacer()
            Button_Filter
        }
        .padding()
    }
    
    private var Button_Filter: some View {
        HStack {
            Picker("Sort Order", selection: $sortOrder) {
                ForEach(SortOder.allCases) { order in
                    Text("Sorted by : \(order.rawValue)").tag(order)
                }
            }
            .buttonStyle(.bordered)
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
}

struct BookItemView: View {
    @Bindable var book: Book
    @State private var rating: Int?
    
    var body: some View {
        HStack {
            book.icon
                .font(.largeTitle)
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                    .foregroundStyle(.secondary)
                
                if book.rating != -1 {
                    RatingsView(maxRating: 5, currentRating: $book.rating).staticRatingsView
                }
                View_Genre
            }
        }
        .padding()
    }
    
    private var View_Genre: some View {
        Group {
            if let genre = book.genres {
                ViewThatFits {
                    GenreStackView(genres: genre)
                    ScrollView(.horizontal) {
                        GenreStackView(genres: genre)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}



#Preview {
    let preview = Preview(Book.self)
    preview.addExamples(Book.sampleBooks)
    preview.addExamples(Genre.sampleGenres)
    return NavigationStack{
        BookListView()
            .modelContainer(preview.container)
    }
    
}
