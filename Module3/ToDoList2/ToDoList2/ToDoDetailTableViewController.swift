//
//  ToDoDetailTableViewController.swift
//  ToDoList2
//
//  Created by Berry, Brett A. (Student) on 11/3/24.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {
    
    //outlets
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //variables
    var isDatePickerHidden: Bool = true
    let dateLabelIndexPath: IndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath: IndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath: IndexPath = IndexPath(row: 0, section: 2)
    
    var toDo: ToDo?
    
    //override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        var currentDueDate: Date
        
        if let toDo = toDo {
          navigationItem.title = "To-Do"
            titleTextField.text = toDo.title
            isCompleteButton.isSelected = toDo.isComplete
            currentDueDate = toDo.dueDate
            notesTextView.text = toDo.notes
        }
        else {
          currentDueDate = Date().addingTimeInterval(24*60*60)
        }
        
        dueDatePicker.date = currentDueDate
        updateDueDateLabel(date: currentDueDate)
        updateSaveButtonState()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath where isDatePickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        default :
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return 216
        case notesIndexPath:
            return 200
        default :
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == dateLabelIndexPath {
            isDatePickerHidden.toggle()
            updateDueDateLabel(date: dueDatePicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePicker.date
        let notes = notesTextView.text
        
        if toDo != nil {
            toDo?.title = title
            toDo?.isComplete = isComplete
            toDo?.dueDate = dueDate
            toDo?.notes = notes
        }
        else{
            toDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
        }
        

        
    }

    //function
    
    //we shouldn't have the save button enabled
    //unless there is an avaiable title
    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = date.formatted(.dateTime.month(.defaultDigits).day().year(.twoDigits).hour().minute())
    }
    
    //IBActions and IBSegues
    
    
    //everytime the text has been editted we
    //can check if the save button should be enabled
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: sender.date)
    }
    
    @IBAction func returnPressed(_ sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonPressed(_ sender: Any) {
        isCompleteButton.isSelected.toggle()
    }
    
}
