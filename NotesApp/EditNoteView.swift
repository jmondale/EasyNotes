//
//  EditNoteView.swift
//  NotesApp
//
//  Created by Jaye Mondale on 8/22/24.
//

import SwiftUI

struct EditNoteView: View {
    @State var note: Note
    @EnvironmentObject var noteData: NoteData
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    @State private var showingDiscardAlert = false

    enum Field { case title, content }

    private var originalNote: Note

    init(note: Note) {
        _note = State(initialValue: note)
        originalNote = note
    }

    private var hasChanges: Bool {
        note.title != originalNote.title || note.content != originalNote.content
    }

    var body: some View {
        VStack {
            TextField("Title", text: $note.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .focused($focusedField, equals: .title)
            TextEditor(text: $note.content)
                .frame(minHeight: 120)
                .border(Color(.separator), width: 1)
                .padding()
                .focused($focusedField, equals: .content)
            Button("Save") {
                if let index = noteData.notes.firstIndex(where: { $0.id == note.id }) {
                    noteData.notes[index] = note
                    noteData.save()
                }
                dismiss()
            }
            .padding()
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .navigationBarBackButtonHidden(hasChanges)
        .toolbar {
            if hasChanges {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        showingDiscardAlert = true
                    }
                }
            }
        }
        .alert("Discard Changes?", isPresented: $showingDiscardAlert) {
            Button("Discard", role: .destructive) { dismiss() }
            Button("Keep Editing", role: .cancel) { }
        } message: {
            Text("You have unsaved changes. Are you sure you want to go back?")
        }
    }
}
