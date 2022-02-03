//
//  NotesListViewController.swift
//  MyNotes
//
//  Created by Roman Efimov on 31.01.2022.
//

import UIKit

class NotesListViewController: UIViewController {
    
    @IBOutlet weak var notesListTableView: UITableView!
    
    
    var dataStoreManager = DataStoreManager()
    var notes: [MyNote] = []
    var indexForSelectedRow = 0
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        notesListTableView.delegate = self
        notesListTableView.dataSource = self
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    

    
    func updateUI(){
        notes.removeAll()
        
        dataStoreManager.fetchData { notes in
            
            guard let notes = notes  else {return}
            if notes == []  && !UserDefaults.standard.bool(forKey: "firstNote"){
                let firstNote = self.dataStoreManager.createFirstNote()
                let myNote = MyNote(date: firstNote.date, text: firstNote.text, title: firstNote.title)
                self.notes.append(myNote)
            }
            for note in notes{
                let myNote = MyNote(date: note.date, text: note.text, title: note.title)
                self.notes.append(myNote)
            }
            self.notesListTableView.reloadData()
        }
    }
    
    
    
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd hh:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let destinationVC = segue.destination as! NoteViewController
            destinationVC.note = notes[indexForSelectedRow]
        }
    }
    
    
  
}




// MARK: - TableViewDelegate & TableViewDataSource

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotesTableViewCell
        cell.titleLabel.text = notes[indexPath.row].title
        if let date = notes[indexPath.row].date {
            cell.dateLabel.text = dateToString(date: date)
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexForSelectedRow = indexPath.row
        performSegue(withIdentifier: "editSegue", sender: nil)
    }
    
    
    
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         

         let contextItem = UIContextualAction(style: .destructive, title: "Удалить") { [self]  (contextualAction, view, boolValue) in
                 
                 if self.notes[indexPath.row].title == "Добро пожаловать в MyNotes!" {
                     UserDefaults.standard.set(true, forKey: "firstNote")
                     self.dataStoreManager.removeNote(date: self.notes[indexPath.row].date!)
                     self.updateUI()

                 } else{
                     self.dataStoreManager.removeNote(date: self.notes[indexPath.row].date!)
                     self.updateUI()
                 }
                 
                     
                     
          
             }
             
         let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
         return swipeActions
         
             
    }
    
    

    
    
}

