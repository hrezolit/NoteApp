//
//  Data+Extension.swift
//  NoteApp
//
//  Created by Nikita on 27/12/22.
//

import Foundation

extension Date {
    
    /// Formating time viewing
    /// - Returns: formated time view
    func format() -> String {
        
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(self) {
            formatter.dateFormat = "h:mm a"
        } else {
            formatter.dateFormat = "dd/MM/yy"
        }
        
        return formatter.string(from: self)
    }
}
