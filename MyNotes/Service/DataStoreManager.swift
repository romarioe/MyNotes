//
//  DataStoreManager.swift
//  MyNotes
//
//  Created by Roman Efimov on 31.01.2022.
//

import Foundation
import CoreData



class DataStoreManager {


// MARK: - Core Data stack

lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "MyNotes")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    } ()
    
    
    
    
    

// MARK: - Core Data Saving support
    
    

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
    
    
    
    
    func fetchData(completion: @escaping ([Note]?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")

        if let notes = try? viewContext.fetch(fetchRequest) as? [Note] {
            completion(notes)
        }
        else {
            completion(nil)
        }
    }
    
    

    
    
    func updateNote(text: NSAttributedString, date: Date){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "date = %@", date as CVarArg)
                             
        if let note = try? viewContext.fetch(fetchRequest) as? [Note] {
           
            guard let note = note.first else {return}
            
            note.text = text
            note.title = getTitle(text: text.string)
            note.date = Date()
            
            saveContext()
        
        }
    }
    
    
    
    
    func createFirstNote() -> Note{
        
      let note = Note(context: viewContext)
        note.title = "Добро пожаловать в MyNotes!"
        note.text = NSMutableAttributedString(string: "Это приложение позволяет создавать заметки и добавлять к ним фото")
        note.date = Date()
        
        saveContext()
        return note
    }
    
    
    
    
    func createNote(text: NSAttributedString){
        
      let note = Note(context: viewContext)
        note.text = text
        note.title = getTitle(text: text.string)
        note.date = Date()
        
        saveContext()
    }
    
     
    
    
    func removeNote(date: Date){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "date = %@", date as CVarArg)
                             
        if let notes = try? viewContext.fetch(fetchRequest) as? [Note] {
            guard let note = notes.first else {return}
            viewContext.delete(note)
            
            saveContext()
        }
    }

    
    
    
    func getTitle(text: String) -> String{
        var returnTitle = "Новая заметка"
        
        if text.count > 32 {
            let index = text.index(text.startIndex, offsetBy: 32)
            let title = text[..<index]
            returnTitle = title + "..."
            
        } else {
            returnTitle = text
        }
        
        return returnTitle
    }
    
    
    

}
