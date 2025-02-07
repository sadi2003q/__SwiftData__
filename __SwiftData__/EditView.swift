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
    
//    @State private var title: String = ""
//    @State private var author: String = ""
//    @State private var dateStarted: Date = Date.distantPast
//    @State private var dateAdded: Date = Date.now
//    @State private var status: Status = .inProgress
//    @State private var dateCompleted: Date = Date.distantFuture
//    @State private var summary: String = ""
//    @State private var rating: Int?
    
    
    
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
            
            
        }
        .padding()
        .navigationTitle("Information")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button_Update
            }
        }
    }
    
    private var View_Status: some View {
        HStack {
            Text("Status")
            Picker("Status", selection: $book.status) {
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
            if book.status == .completed || book.status == .inProgress {
                View_DateStarted
            }
            if book.status == .completed {
                View_DateCompleted
            }
            
        }
        .onChange(of: book.status) { oldValue, newValue in
            
            if newValue == .onShelf {
                book.dateStarted = Date.distantPast
                book.dateCompleted = Date.distantPast
            } else if newValue == .inProgress && oldValue == .completed {
                // from completed to inProgress
                book.dateCompleted = Date.distantPast
            } else if newValue == .inProgress && oldValue == .onShelf {
                // Book has been started
                book.dateStarted = Date.now
            } else if newValue == .completed && oldValue == .onShelf {
                // Forgot to start book
                book.dateCompleted = Date.now
                book.dateStarted = book.dateAdded
            } else {
                // completed
                book.dateCompleted = Date.now
            }
            
        }
        
    }
    
    private var View_DateAdded: some View {
        LabeledContent {
            DatePicker("", selection: $book.dateAdded, in: book.dateAdded..., displayedComponents: .date)
        } label: {
            Text("Date Added")
        }
    }
    
    private var View_DateStarted: some View {
        LabeledContent {
            DatePicker("", selection: $book.dateStarted, in: book.dateAdded..., displayedComponents: .date)
        } label: {
            Text("Date Started")
        }
    }
    
    private var View_DateCompleted: some View {
        LabeledContent {
            DatePicker("", selection: $book.dateCompleted, in: book.dateAdded..., displayedComponents: .date)
        } label: {
            Text("Date Completed")
        }
    }
    
    private var View_Rating: some View {
        LabeledContent {
            RatingsView(maxRating: 5, currentRating: $book.rating, width: 30)
        } label: {
            Text("Rating")
        }
    }
    
    private var View_Title: some View {
        LabeledContent {
            TextField("", text: $book.title).bold()
        } label: {
            Text("Title").foregroundStyle(.secondary)
        }
    }
    
    private var View_Author: some View {
        LabeledContent {
            TextField("", text: $book.author).bold()
        } label: {
            Text("Author").foregroundStyle(.secondary)
        }
    }
    
    private var View_Summary: some View {
        VStack(alignment: .leading) {
            Text("Summary").underline()
            TextEditor(text: $book.summary)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
        }
        
    }
    
    private var Button_Update: some View {
        Button("Update") {
            dismiss()
            try? context.save()
        }
        .buttonStyle(.borderedProminent)
        
    }
    
    
}
//
//#Preview {
//    NavigationStack {
//        EditView()
//    }
//}
