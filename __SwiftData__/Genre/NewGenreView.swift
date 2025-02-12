//
//  NewGenreView.swift
//  __SwiftData__
//
//  Created by  Sadi on 12/02/2025.
//

import SwiftUI
import SwiftData


struct NewGenreView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var color: Color = .blue
    
    
    
    var body: some View {
        NavigationStack {
            Form_NewGenre
        }
    }
    
    private var Form_NewGenre: some View {
        Form {
            TextField("Name", text: $name)
            ColorPicker("Set the Color", selection: $color)
            
            Button_SaveGenre
            
            
        }
        .padding()
        .navigationTitle("New Genre")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var Button_SaveGenre: some View {
        Button("Create") {
            let genre = Genre(name: name, color: color.toHexString() ?? "#000000")
            modelContext.insert(genre)
            dismiss()
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .disabled(name.isEmpty)

    }
    
    
    
}

#Preview {
    NewGenreView()
}
