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
    var summary: String
    var rating: Int?
    
    var status: Status
    
    init(
        id: UUID = UUID(),
        title: String,
        author: String,
        dateStarted: Date = Date.now,
        dateAround: Date = Date.distantPast,
        dateCompleted: Date = Date.distantFuture,
        summary: String = "",
        rating: Int = -1,
        status: Status = .onShelf
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.dateStarted = dateStarted
        self.dateAdded = dateAround
        self.dateCompleted = dateCompleted
        self.summary = summary
        self.rating = rating
        self.status = status
    }
    
    
    var icon: Image {
        switch status {
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
