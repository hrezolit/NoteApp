//
//  Note.swift
//  NoteApp
//
//  Created by Nikita on 27/12/22.
//

import Foundation

class Note {
    
    let id = UUID()
    var text: String = ""
    var lastUpdated: Date = Date()
    
    // Note's title
    var title: String {
        
        return text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .first ?? ""
    }
    
    // Description of note's update time
    var description: String {
        
        var lines = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
        lines.removeFirst()
        
        return "\(lastUpdated.format()) \(lines.first ?? "")"
    }
}
