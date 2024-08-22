//
//  NoteData.swift
//  NotesApp
//
//  Created by Jaye Mondale on 8/22/24.
//

import Foundation

class NoteData: ObservableObject {
    @Published var notes: [Note] = []

    private let filename = "notes.json"

    init() {
        load()
    }

    func add(note: Note) {
        notes.append(note)
        save()
    }

    func remove(atOffsets offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        save()
    }

    func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(notes) {
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            try? data.write(to: url)
        }
    }

    private func load() {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let loadedNotes = try? decoder.decode([Note].self, from: data) {
                notes = loadedNotes
            }
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

