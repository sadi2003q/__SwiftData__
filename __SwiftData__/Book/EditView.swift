//
//  EditView.swift
//  __SwiftData__
//
//  Created by  Sadi on 07/02/2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditView: View {
    
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Bindable var book: Book
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var dateStarted: Date = Date.distantPast
    @State private var dateAdded: Date = Date.now
    @State private var status: Status = .onShelf
    @State private var dateCompleted: Date = Date.distantFuture
    @State private var summary: String = ""
    @State private var rating: Int?
    @State private var showGenres: Bool = false
    
    
    @State private var selectedBookCover : PhotosPickerItem?
    @State private var selectedBookCoverData: Data?
    
   
    
    var body: some View {
        VStack {
            View_Status
            View_BookDate
            View_Rating
            
            Divider()
            HStack {
                PhotosPicker_BookCover
                VStack {
                    View_Title
                    View_Author
                }
            }
            
            
            Divider()
            View_Summary
            View_Genre
            Button_Accessories
        }
        .padding()
        .navigationTitle("Information")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if change {
                    Button_Update
                }
            }
        }
        .onAppear {
            onAppear_Value()
        }
        .task(id: selectedBookCover) {
            if let data = try? await selectedBookCover?.loadTransferable(type: Data.self) {
                selectedBookCoverData = data
            }
        }
    }
    
    private var View_Status: some View {
        HStack {
            Text("Status")
            Picker("Status", selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.description).tag(status)
                }
            }
            .buttonStyle(.bordered)
        }
    }
    
    private var View_BookDate: some View {
        VStack {
            View_DateAdded
            if status == .completed || status == .inProgress {
                View_DateStarted
            }
            if status == .completed {
                View_DateCompleted
            }
            
        }
        .onChange(of: status) { oldValue, newValue in
            
            if newValue == .onShelf {
                dateStarted = Date.distantPast
                dateCompleted = Date.distantPast
            } else if newValue == .inProgress && oldValue == .completed {
                // from completed to inProgress
                dateCompleted = Date.distantPast
            } else if newValue == .inProgress && oldValue == .onShelf {
                // Book has been started
                dateStarted = Date.now
            } else if newValue == .completed && oldValue == .onShelf {
                // Forgot to start book
                dateCompleted = Date.now
                dateStarted = dateAdded
            } else {
                // completed
                dateCompleted = Date.now
            }
            
        }
        
    }
    
    private var PhotosPicker_BookCover: some View {
        PhotosPicker(
            selection: $selectedBookCover,
            matching: .images,
            photoLibrary: .shared()
        ) {
            
            Group {
                if let selectedBookCoverData,
                   let uiImage = UIImage(data: selectedBookCoverData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .tint(.primary)
                }
            }
            .frame(width: 79, height: 100)
            .overlay(alignment: .bottomTrailing) {
                if selectedBookCoverData != nil {
                    Button {
                        selectedBookCover = nil
                        selectedBookCoverData = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
                
            
        }
    }
    
    
    
    private var View_DateAdded: some View {
        LabeledContent {
            switch status {
                case .onShelf:
                    DatePicker("", selection: $dateAdded, displayedComponents: .date)
                case .inProgress, .completed:
                    DatePicker("", selection: $dateAdded, in: ...dateStarted, displayedComponents: .date)
            }
        } label: {
            Text("Date Added")
        }
    }
    
    private var View_DateStarted: some View {
        LabeledContent {
            DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date)
        } label: {
            Text("Date Started")
        }
    }
    
    private var View_DateCompleted: some View {
        LabeledContent {
            DatePicker("", selection: $dateCompleted, in: dateAdded..., displayedComponents: .date)
        } label: {
            Text("Date Completed")
        }
    }
    
    private var View_Rating: some View {
        LabeledContent {
            RatingsView(maxRating: 5, currentRating: $rating, width: 30)
        } label: {
            Text("Rating")
        }
    }
    
    private var View_Title: some View {
        LabeledContent {
            TextField("", text: $title).bold()
        } label: {
            Text("Title").foregroundStyle(.secondary)
        }
    }
    
    private var View_Author: some View {
        LabeledContent {
            TextField("", text: $author).bold()
        } label: {
            Text("Author").foregroundStyle(.secondary)
        }
    }
    
    private var View_Summary: some View {
        VStack(alignment: .leading) {
            Text("Summary").underline()
            TextEditor(text: $summary)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
        }
        
    }
    
    private var Button_Update: some View {
        Button("Update") {
            
            onChange_Value()
            try? context.save()
            
            dismiss()
        }
        .buttonStyle(.borderedProminent)
        
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
    
    private var Button_Accessories: some View {
        HStack {
            Button_Quote
            Button_Genre
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal)
    }
    
    private var Button_Quote: some View {
        NavigationLink {
            QuoteListView(book: book)
        } label: {
            let count = book.quotes?.count ?? 0
            Label("^[\(count) Quotes](inflect: true)", systemImage: "quote.opening")
        }
        .buttonStyle(.bordered)
        
        
    }
    
    private var Button_Genre: some View {
        Button("Genre", systemImage: "bookmark.fill") {
            showGenres.toggle()
        }
        .buttonStyle(.bordered)
        .sheet(isPresented: $showGenres) {
            GenresView(book: book)
        }
    }
    
    
    var change: Bool {
        status != Status(rawValue: book.status)
        || rating != book.rating
        || title != book.title
        || author != book.author
        || summary != book.synopsis
        || dateAdded != book.dateAdded
        || dateStarted != book.dateStarted
        || dateCompleted != book.dateCompleted
        || selectedBookCoverData != book.bookCover
    }
    
    
    
    private func onAppear_Value() {
//        status = Status(rawValue: book.status) ?? .inProgress
        title = book.title
        author = book.author
        dateAdded = book.dateAdded
        dateStarted = book.dateAdded
        dateCompleted = book.dateCompleted
        summary = book.synopsis
        rating = book.rating == -1 ? 0 : book.rating
        selectedBookCoverData = book.bookCover
    }
    
    private func onChange_Value() {
        book.title = title
        book.author = author
        dateAdded = book.dateAdded
        dateStarted = book.dateStarted
        book.status = status.rawValue
        book.dateCompleted = dateCompleted
        
        book.synopsis = summary
        book.rating = rating
        book.bookCover = selectedBookCoverData
        
    }
    
    
}


#Preview {
    /*
    //let _ = Preview(Book.self)
    let book = Book.sampleBooks[5]
    return NavigationStack {
        EditView(book: book)
    }
    */
    
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
        EditView(book: books[1])
            .modelContainer(preview.container)
    }
}


