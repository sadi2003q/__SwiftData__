//
//  Quote.swift
//  __SwiftData__
//
//  Created by  Sadi on 10/02/2025.
//

import Foundation
import SwiftData

@Model
class Quote {
    var creationDate = Date.now
    var text: String
    var page : String?
    
    init(text: String, page: String? = nil) {
        self.text = text
        self.page = page
    }
    
    var book: Book?
}
