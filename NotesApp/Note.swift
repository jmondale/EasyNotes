//
//  Note.swift
//  NotesApp
//
//  Created by Jaye Mondale on 8/22/24.
//

import Foundation

struct Note: Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
}

