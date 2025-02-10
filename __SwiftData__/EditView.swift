//
//  EditView.swift
//  __SwiftData__
//
//  Created by  Sadi on 07/02/2025.
//

import SwiftUI
import SwiftData


struct EditView: View {
    
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Bindable var book: Book
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var dateStarted: Date = Date.distantPast
    @State private var dateAdded: Date = Date.now
    @State private var status: Status = .inProgress
    @State private var dateCompleted: Date = Date.distantFuture
    @State private var summary: String = ""
    @State private var rating: Int?
    
    
    
    var body: some View {
        VStack {
            View_Status
            View_BookDate
            View_Rating
            
            Divider()
            View_Title
            View_Author
            
            Divider()
            View_Summary
            Button_Quote
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
    
    private var View_DateAdded: some View {
        LabeledContent {
            DatePicker("", selection: $dateAdded, in: dateAdded..., displayedComponents: .date)
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
    
    private var Button_Quote: some View {
        NavigationLink {
            QuoteListView(book: book)
        } label: {
            let count = book.quotes?.count ?? 0
            Label("^[\(count) Quotes](inflect: true)", systemImage: "quote.opening")
        }
        .buttonStyle(.bordered)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal)
        
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
    }
    
    
    
    private func onAppear_Value() {
        status = Status(rawValue: book.status) ?? .inProgress
        title = book.title
        author = book.author
        dateAdded = book.dateAdded
        dateStarted = book.dateAdded
        dateCompleted = book.dateCompleted
        summary = book.synopsis
        rating = book.rating == -1 ? 0 : book.rating
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
    }
    
    
}


#Preview {
    //let _ = Preview(Book.self)
    return NavigationStack {
        EditView(book: Book.sampleBooks[5])
    }
    
    
}
