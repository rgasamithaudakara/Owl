//
//  AddItemViewController.swift
//  Master Detailed App Version 02
//
//  Created by Wagee Ishani on 5/21/19.
//  Copyright © 2019 Wagee Ishani. All rights reserved.
//

import UIKit
import EventKit

class AddItemViewController: UIViewController, UITextFieldDelegate {
    
    var newProjectPriority = "Low"
    
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var prioritySegmentControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var projectDescription: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var calendarAlertSwitch: UISwitch!
    
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func prioritySegmentControlAction(_ sender: Any) {
        if prioritySegmentControl.selectedSegmentIndex == 0 {
            newProjectPriority = "Low"
        } else if prioritySegmentControl.selectedSegmentIndex == 1 {
            newProjectPriority = "Medium"
        } else if prioritySegmentControl.selectedSegmentIndex == 2 {
            newProjectPriority = "High"
        }
    }
    
    @IBAction func submitNewItemForm(_ sender: Any) {
        
        if calendarAlertSwitch.isOn{
            let eventStore : EKEventStore = EKEventStore()
            
            eventStore.requestAccess(to: .event) { (granted, error) in
                
                if (granted) && (error == nil) {
                    print("granted \(granted)")
                    
                    let event:EKEvent = EKEvent(eventStore: eventStore)

                    event.title = self.projectName.text!
                    event.startDate = Date()
                    event.endDate = self.datePicker.date
                    event.notes = "\(self.projectName.text!) starts from \(Date()) and has to be completed by \(self.datePicker.date)"
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                    }
                    print("Saved Event")
                }
            }
        }
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        if projectName.text != "" && projectDescription.text != ""{
        let newProject = Project(context: context)
        
            newProject.projectName = projectName.text
            newProject.projectDescription = projectDescription.text
            newProject.projectPriority = newProjectPriority
            newProject.projectDeadline = "\(dateFormatter.string(from: datePicker.date))"
            newProject.projectComplete = Float(0)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }else{
            let alert = UIAlertController(title: "Misisng some values", message: "Please enter all required inputs", preferredStyle: .alert)
            let okayaction = UIAlertAction(title: "okay", style: .default, handler: nil)
            alert.addAction(okayaction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        doneButton.layer.cornerRadius = 5
        projectName.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
