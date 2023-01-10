//
//  MainPageViewController.swift
//  NoteApp
//
//  Created by Nikita on 27/12/22.
//

import UIKit
import CoreData

protocol MainPageDelegate: AnyObject {
    func refreshNotes()
    func deleteNote(with id: UUID)
}

class MainPageViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var notesCountLabel: UILabel!
    
    private let searchController = UISearchController()
    
    private var allNotes: [Note] = [] {
        didSet {
            notesCountLabel.text = "\(allNotes.count) \(allNotes.count == 1 ? "Note" : "Notes")"
            filteredNotes = allNotes
        }
    }
    
    private var filteredNotes: [Note] = []
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        tableView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        configureSearchBar()
        fetchNotesFromStorage()
    }
    
    private func indexForNote(id: UUID, in list: [Note]) -> IndexPath {
        let row = Int(list.firstIndex(where: { $0.id == id }) ?? 0)
        return IndexPath(row: row, section: 0)
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
    }
    
    @IBAction func newNoteButtonPressed(_ sender: UIButton) {
        goToEditNote(createNote())
    }
    
    private func goToEditNote(_ note: Note) {
        let controller = storyboard?.instantiateViewController(identifier: EditPageViewController.identifier) as! EditPageViewController
        controller.note = note
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Methods to implement
    private func createNote() -> Note {
        let note = CoreDataManager.shared.createNote()
        // Update table view
        allNotes.insert(note, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        return note
    }
    
    private func fetchNotesFromStorage() {
        
       allNotes = CoreDataManager.shared.fetchNotes()
        
    }
    
    private func deleteNoteFromStorage(_ note: Note) {
        deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note)
    }
    
    private func searchNotesFromStorage(_ text: String) {
        allNotes = CoreDataManager.shared.fetchNotes(filter: text)
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource & Delegate
extension MainPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: MainPageTableViewCell.identifier) as! MainPageTableViewCell
        cell.setup(note: filteredNotes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToEditNote(filteredNotes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNoteFromStorage(filteredNotes[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - Search Controller Delegate
extension MainPageViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchNotesFromStorage(query)
    }
    
    func search(_ query: String) {
        if query.count >= 1 {
            filteredNotes = allNotes.filter { $0.text.lowercased().contains(query.lowercased()) }
        } else{
            filteredNotes = allNotes
        }
        
        tableView.reloadData()
    }
}

// MARK: - MainPageViewController Delegate
extension MainPageViewController: MainPageDelegate {
    
    func refreshNotes() {
        allNotes = allNotes.sorted(by: { $0.lastUpdate > $1.lastUpdate })
        tableView.reloadData()
    }
    
    func deleteNote(with id: UUID) {
        let indexPath = indexForNote(id: id, in: filteredNotes)
        filteredNotes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        allNotes.remove(at: indexForNote(id: id, in: allNotes).row)
    }
}


