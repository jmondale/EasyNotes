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
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(notes)
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            try data.write(to: url)
        } catch {
            print("EasyNotes: Failed to save notes: \(error)")
        }
    }

    private func load() {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        do {
            let data = try Data(contentsOf: url)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("EasyNotes: Failed to load notes: \(error)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("EasyNotes: Documents directory unavailable")
        }
        return url
    }
}

