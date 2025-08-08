//
//  Note.swift
//  Noty
//
//  Created by Moheb Anwari on 05.08.25.
//

import Foundation

struct Note: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var tags: [String]
    
    init(title: String, content: String, tags: [String] = []) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.date = Date()
        self.tags = tags
    }
}
