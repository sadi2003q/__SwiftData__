//
//  Genre.swift
//  __SwiftData__
//
//  Created by  Sadi on 11/02/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Genre {
    
    var name: String
    var color: String
    
    var books: [Book]?
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
    
    var hexColor: Color {
        Color(hex: self.color) ?? .red
    }

}
