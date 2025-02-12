//
//  GenreStackView.swift
//  __SwiftData__
//
//  Created by  Sadi on 12/02/2025.
//

import SwiftUI

struct GenreStackView: View {
    
    var genres : [Genre]
    
    var body: some View {
        HStack {
            View_AllAssignedGenres
        }
    }
    
    private var View_AllAssignedGenres: some View {
        
            ForEach(genres.sorted(using: KeyPathComparator(\Genre.name))) { genre in
                Text(genre.name)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 6).fill(genre.hexColor))
            }
       
    }
}

