//
//  EditNoteView.swift
//  NotesApp
//
//  Created by Jaye Mondale on 8/22/24.
//

import SwiftUI

struct EditNoteView: View {
    @State var note: Note
    @ObservedObject var noteData: NoteData
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("Title", text: $note.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextEditor(text: $note.content)
                .border(Color.gray, width: 1)
                .padding()
            Button("Save") {
                if let index = noteData.notes.firstIndex(where: { $0.id == note.id }) {
                    noteData.notes[index] = note
                    noteData.save()
                }
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
    }
}

