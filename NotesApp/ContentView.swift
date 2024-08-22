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

    var body: some View {
        NavigationView {
            List {
                ForEach(noteData.notes) { note in
                    NavigationLink(destination: EditNoteView(note: note, noteData: noteData)) {
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
            })
            .sheet(isPresented: $showingAddNote) {
                VStack {
                    TextField("Title", text: $newNoteTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)

                    TextEditor(text: $newNoteContent)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)

                    Button("Save") {
                        let newNote = Note(title: newNoteTitle, content: newNoteContent)
                        noteData.add(note: newNote)
                        newNoteTitle = ""
                        newNoteContent = ""
                        showingAddNote = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .shadow(radius: 10)
            }
        }
    }
}


#Preview {
    ContentView()
}
