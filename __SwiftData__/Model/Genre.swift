//
//  Genre.swift
//  __SwiftData__
//
//  Created by  Sadi on 11/02/2025.
//

import Foundation
import SwiftData

@Model
class Genre {
    
    var name: String
    var color: String
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }

}
