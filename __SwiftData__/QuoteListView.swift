//
//  QuoteListView.swift
//  __SwiftData__
//
//  Created by  Sadi on 10/02/2025.
//

import SwiftUI

struct QuoteListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    let book: Book
    
    @State private var text: String = ""
    @State private var page : String = ""
    @State private var selectedQuote: Quote?
    
    var isEditing : Bool {
        selectedQuote != nil
    }
    
    var body: some View {
        VStack {
            View_QuoteCustomisation
            List_AllQuotes
        }
    }
    
    
    private var View_QuoteCustomisation: some View {
        GroupBox {
            HStack {
                View_PageTextField
                Spacer()
                Button_CreateUpdate
                if isEditing {
                    Button_Cancel
                }
            }
            
            
            TextEditor_QuoteText
        }
        .padding(.horizontal)
    }
    
    private var View_PageTextField: some View {
        Group {
            Text("**Page**: ")
            TextField("#Page", text: $page)
                .autocorrectionDisabled(true)
                .textFieldStyle(.roundedBorder)
                .frame(width: 150)
        }
    }
    
    private var Button_Cancel: some View {
        Button("Cancel") {
            page = ""
            text = ""
            selectedQuote = nil
        }
    }
    
    private var Button_CreateUpdate: some View {
        Button(isEditing ? "Update" : "Create") {
            if isEditing {
                selectedQuote?.text = text
                selectedQuote?.page = page.isEmpty ? nil : page
//                _makeEmpty()
            } else {
                let quote = page.isEmpty ? Quote(text: text) : Quote(text: text, page: page)
                book.quotes?.append(quote)
//                _makeEmpty()
            }
            _makeEmpty()
        }
        .buttonStyle(.borderedProminent)
        .disabled(text.isEmpty)
    }
    
    private var TextEditor_QuoteText: some View {
        TextEditor(text: $text)
            .border(Color.secondary)
            .frame(height: 100)
    }
    
    private func _makeEmpty() {
        text = ""
        page = ""
        selectedQuote = nil
    }
    
    
    private var List_AllQuotes: some View {
        List {
            let sortQuotes = book.quotes?.sorted(using: KeyPathComparator(\Quote.creationDate)) ?? []
            
            ForEach(sortQuotes) { quote in
                View_QuoteList(for: quote)
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.plain)
        .navigationTitle("Quotes")
    }
    
    private func deleteItems(at offsets: IndexSet) {
        offsets.forEach { index in
            if let quote = book.quotes?[index] {
                modelContext.delete(quote)
            }
        }
    }
    
    private func View_QuoteList(for quote: Quote) -> some View {
        return VStack(alignment: .leading) {
            Text(quote.creationDate, format: .dateTime.month().day().year())
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(quote.text)
            HStack {
                Spacer()
                if let page = quote.page, !page.isEmpty {
                    Text("Page: \(page)")
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectedQuote = quote
            text = quote.text
            page = quote.page ?? ""
        }
    }

}

#Preview {
    
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    preview.addExamples(books)
    
    return NavigationStack {
        QuoteListView(book : books[3])
            .modelContainer(preview.container)
    }
}
