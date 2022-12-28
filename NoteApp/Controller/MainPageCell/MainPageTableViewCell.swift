//
//  MainPageTableViewCell.swift
//  NoteApp
//
//  Created by Nikita on 27/12/22.
//

import UIKit

class MainPageTableViewCell: UITableViewCell {

    static let identifier = "MainPageTableViewCell"
    
    @IBOutlet weak private var titleLable: UILabel!
    @IBOutlet weak private var descriptionLable: UILabel!
    
    /// Seting up title & description
    /// - Parameter note: Model implementation
    func setup(note: Note) {
        
        titleLable.text = note.title
        descriptionLable.text = note.description
    }
}
