//
//  Book.swift
//  __SwiftData__
//
//  Created by  Sadi on 01/02/2025.
//

import SwiftUI
import SwiftData

@Model
class Book {
    var id: UUID
    var title: String
    var author: String
    var dateStarted: Date
    var dateAdded: Date
    var dateCompleted: Date
    @Attribute(originalName: "summary") /// Rename one attribute
    var synopsis: String
    var rating: Int?
    
    @Relationship(deleteRule: .cascade) /// this will help to delete the data when there is one to many relation
    var quotes: [Quote]?
    
    @Relationship(inverse: \Genre.books)
    var genres: [Genre]?
    
    var status: Status.RawValue
    
    init(
        id: UUID = UUID(),
        title: String,
        author: String,
        dateStarted: Date = Date.now,
        dateAdded: Date = Date.distantPast,
        dateCompleted: Date = Date.distantFuture,
        synopsis: String = "",
        rating: Int = -1,
        status: Status = .onShelf
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.dateStarted = dateStarted
        self.dateAdded = dateAdded
        self.dateCompleted = dateCompleted
        self.synopsis = synopsis
        self.rating = rating
        self.status = status.rawValue
    }
    
    
    var icon: Image {
        switch Status(rawValue: status)! {
        case .onShelf:
            Image(systemName: "checkmark.diamond.fill")
        case .inProgress:
            Image(systemName: "book.fill")
        case .completed:
            Image(systemName: "books.vertical.fill")
            
        }
    }
}


enum  Status: Int, Codable, Identifiable, CaseIterable {
    case onShelf
    case inProgress
    case completed
    
    var id: Self {
        self
    }
    
    var description: String {
        switch self {
        case .onShelf:
            return "On Shelf"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        }
    }
}
