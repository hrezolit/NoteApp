//
//  EditPageViewController.swift
//  NoteApp
//
//  Created by Nikita on 27/12/22.
//

import UIKit

class EditPageViewController: UIViewController {
    
    static let identifier = "EditPageViewController"
    
    var note: Note!
    weak var delegate: MainPageDelegate?

    @IBOutlet weak private var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = note?.text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK:- Methods to implement
    private func updateNote() {
        note.lastUpdate = Date()
        CoreDataManager.shared.save()
        delegate?.refreshNotes()
    }
    
    private func deleteNote() {
  
        delegate?.deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note )
    }
}

// MARK:- UITextView Delegate
extension EditPageViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note?.text = textView.text
        if note?.title.isEmpty ?? true {
            deleteNote()
        } else {
            updateNote()
        }
    }
}

