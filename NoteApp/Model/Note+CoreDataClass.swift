//
//  Note+CoreDataClass.swift
//  NoteApp
//
//  Created by Nikita on 29/12/22.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {

    // Note's title
    var title: String {
        
        return text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .first ?? ""
    }
    
    // Description of note's update time
    public override var description: String {
        
        var lines = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
        lines.removeFirst()
        
        return "\(lastUpdate.format()) \(lines.first ?? "")"
    }
}
