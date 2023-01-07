//
//  Note+CoreDataProperties.swift
//  NoteApp
//
//  Created by Nikita on 29/12/22.
//
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: UUID!
    @NSManaged public var text: String!
    @NSManaged public var lastUpdate: Date!

}

extension Note : Identifiable {

}
