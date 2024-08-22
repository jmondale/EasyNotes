//
//  NoteRowView.swift
//  NotesApp
//
//  Created by Jaye Mondale on 8/22/24.
//

import SwiftUI

struct NoteRowView: View {
    var note: Note

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(note.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(note.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

