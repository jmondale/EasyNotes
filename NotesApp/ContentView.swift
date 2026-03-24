//
//  ContentView.swift
//  NotesApp
//
//  Created by Jaye Mondale on 8/22/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var noteData = NoteData()
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    @State private var showingAddNote = false
    @FocusState private var focusedField: Field?

    enum Field { case title, content }

    private var canSave: Bool {
        !newNoteTitle.trimmingCharacters(in: .whitespaces).isEmpty ||
        !newNoteContent.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(noteData.notes) { note in
                    NavigationLink(destination: EditNoteView(note: note)) {
                        NoteRowView(note: note)
                    }
                }
                .onDelete(perform: { offsets in
                    withAnimation {
                        noteData.remove(atOffsets: offsets)
                    }
                })
            }
            .navigationTitle("Notes")
            .navigationBarItems(trailing: Button(action: {
                showingAddNote = true
            }) {
                Image(systemName: "plus")
                    .imageScale(.large)
            }
            .accessibilityLabel("Add Note"))
            .sheet(isPresented: $showingAddNote) {
                VStack {
                    TextField("Title", text: $newNoteTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .focused($focusedField, equals: .title)

                    TextEditor(text: $newNoteContent)
                        .frame(minHeight: 120)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .focused($focusedField, equals: .content)

                    Button("Save") {
                        let newNote = Note(title: newNoteTitle, content: newNoteContent)
                        noteData.add(note: newNote)
                        newNoteTitle = ""
                        newNoteContent = ""
                        showingAddNote = false
                    }
                    .padding()
                    .background(canSave ? Color.accentColor : Color(.systemGray4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(!canSave)
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(15)
                .shadow(radius: 10)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { focusedField = nil }
                    }
                }
            }
        }
        .environmentObject(noteData)
    }
}


#Preview {
    ContentView()
}
