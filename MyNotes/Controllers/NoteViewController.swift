//
//  NoteViewController.swift
//  MyNotes
//
//  Created by Roman Efimov on 31.01.2022.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    
    var dataStoreManager = DataStoreManager()
    var note: MyNote?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let note = note else {return}
        noteTextView.attributedText = note.text
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let note = note {
            dataStoreManager.updateNote(text: noteTextView.attributedText, date: note.date!)
        } else {
            if !noteTextView.text.isEmpty{
                dataStoreManager.createNote(text: noteTextView.attributedText)
            }
        }
        
        
        
    }
    

    
    // MARK: - Text style buttons
    
    
    @IBAction func boldButton(_ sender: Any) {
        
        if let text = noteTextView {
            let range = text.selectedRange
            let string = NSMutableAttributedString(attributedString:
                                                    noteTextView.attributedText)
            let boldAttribute = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: noteTextView.font!.pointSize)
            ]
            string.addAttributes(boldAttribute, range: noteTextView.selectedRange)
            noteTextView.attributedText = string
            noteTextView.selectedRange = range
        }
    }
    
    
    
    @IBAction func italicButton(_ sender: Any) {
        if let text = noteTextView {
            let range = text.selectedRange
            let string = NSMutableAttributedString(attributedString:
                                                    noteTextView.attributedText)
            let italicAttribute = [
                NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: noteTextView.font!.pointSize)
            ]
            string.addAttributes(italicAttribute, range: noteTextView.selectedRange)
            noteTextView.attributedText = string
            noteTextView.selectedRange = range
        }
    }
    
    
    
    @IBAction func sizePlus(_ sender: Any) {
        if let text = noteTextView {
            let range = text.selectedRange
            let string = NSMutableAttributedString(attributedString:
                                                    noteTextView.attributedText)
            let textAttribute = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: noteTextView.font!.pointSize+1)
            ]
            string.addAttributes(textAttribute, range: noteTextView.selectedRange)
            noteTextView.attributedText = string
            noteTextView.selectedRange = range
        }
    }
    
    
    
    @IBAction func sizeMinus(_ sender: Any) {
        if let text = noteTextView {
            let range = text.selectedRange
            let string = NSMutableAttributedString(attributedString:
                                                    noteTextView.attributedText)
            let textAttribute = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: noteTextView.font!.pointSize-1)
            ]
            string.addAttributes(textAttribute, range: noteTextView.selectedRange)
            noteTextView.attributedText = string
            noteTextView.selectedRange = range
        }
    }
    
    
 
    
    // MARK: - Add image to note
    

    @IBAction func addImage(_ sender: Any) {
        cameraOrLibrary()
    }
    
    
   
    private func cameraOrLibrary(){
        
        let alert = UIAlertController(title: "", message: "Выберите откуда вы хотите получить изображение", preferredStyle: UIAlertController.Style.alert)
        let camera = UIAlertAction(title: "Камера", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
           
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true)
        })
        alert.addAction(camera)
        
        
        let galery = UIAlertAction(title: "Галерея", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
         })
         alert.addAction(galery)
        
        self.present(alert, animated: true, completion: nil)
    }
    
   
}




extension NoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let attachment = NSTextAttachment()
        attachment.image = image
        let mutableAttributedString = NSMutableAttributedString(attributedString: noteTextView.attributedText)
        mutableAttributedString.append(NSAttributedString(attachment: attachment))
        noteTextView.attributedText = mutableAttributedString
        dismiss(animated: true)
    }
    
 
}
