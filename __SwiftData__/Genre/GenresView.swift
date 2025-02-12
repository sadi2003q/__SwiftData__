//
//  GenresView.swift
//  __SwiftData__
//
//  Created by  Sadi on 12/02/2025.
//

import SwiftUI
import SwiftData


struct GenresView: View {
    
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Genre.name) private var genres: [Genre]
    @Bindable var book: Book
    
    @State private var newGenre : Bool = false
    
    
    var body: some View {
        Group {
            if genres.isEmpty {
                View_ContentNotAvailable
            } else {
                List_Genre
            }
            
        }
        .navigationTitle(book.title)
        .sheet(isPresented: $newGenre) {
            NewGenreView()
        }
    }
    
    
    private var View_ContentNotAvailable: some View {
        ContentUnavailableView {
            Image(systemName: "bookmark.fill")
                .font(.largeTitle)
        } description: {
            Text("Yuu need to create some Genre First")
        } actions: {
            Button("Create Genre") {
                newGenre.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var List_Genre: some View {
        List {
            ForEach(genres) { genre in
                if let bookGenre = book.genres {
                    HStack {
                        if bookGenre.isEmpty {
                            Button {
                                addRemove(genre)
                            } label: {
                                Image(systemName: "circle")
                            }
                            .foregroundStyle(genre.hexColor)
                            
                        } else {
                            Button {
                                addRemove(genre)
                            } label: {
                                Image(systemName: bookGenre.contains(genre) ? "circle.fill" : "circle")
                            }
                            .foregroundStyle(genre.hexColor)
                            
                        }
                        Text(genre.name)
                    }
                    
                }
            }
            .onDelete(perform: onDelete)
            
            Button_CreateNewGenre
            
        }
        .listStyle(.plain)
    }
    
    private var Button_CreateNewGenre: some View {
        LabeledContent {
            Button {
                newGenre.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
            }
            .buttonStyle(.borderedProminent)
            
        } label: {
            Text("Create New Genre")
                .font(.caption).foregroundStyle(.secondary)
        }
        
    }
    
    private func addRemove(_ genre: Genre) {
        if let bookGenres = book.genres {
            if bookGenres.isEmpty {
                book.genres?.append(genre)
            } else {
                if bookGenres.contains(genre),
                   let index = bookGenres.firstIndex(where: {$0.id == genre.id}) {
                    book.genres?.remove(at: index)
                } else {
                    book.genres?.append(genre)
                }
            }
        }
    }
    
    private func onDelete(indexSet: IndexSet) {
        indexSet.forEach { index in
            if let bookGenres = book.genres,
               bookGenres.contains(genres[index]),
               let bookGenreIndex = bookGenres.firstIndex(where: {$0.id == genres[index].id}) {
                book.genres?.remove(at: bookGenreIndex)
            }
            context.delete(genres[index])
        }
    }
    
    
}

//#Preview {
//    
//    let preview = Preview(Book.self)
//    let books = Book.sampleBooks
//    let genres = Genre.sampleGenres
//    
//    preview.addExamples(books)
//    preview.addExamples(genres)
//    
//    books[1].genres?.append(genres[1])
//    
//    return NavigationStack {
//        GenresView(book: books[1])
//            .modelContainer(preview.container)
//    }
//    
//    
//}
#Preview {
    
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    let genres = Genre.sampleGenres
    
    preview.addExamples(books)
    preview.addExamples(genres)
    
    // Ensure book.genres is initialized
    if books[1].genres == nil {
        books[1].genres = []
    }
    
    // Add a genre to the book
    books[1].genres?.append(genres[0])
    
    return NavigationStack {
        GenresView(book: books[1])
            .modelContainer(preview.container)
    }
}
