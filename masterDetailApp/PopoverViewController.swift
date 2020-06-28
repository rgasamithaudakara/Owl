//
//  PopoverViewController.swift
//  Master Detailed App Version 02
//
//  Created by Wagee Ishani on 5/21/19.
//  Copyright © 2019 Wagee Ishani. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class PopoverViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var popoverTitle: UILabel!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDescription: UITextField!
    @IBOutlet weak var stardDatePicker: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notifySwitch: UISwitch!
    @IBOutlet weak var submitButton: UIButton!
    var currentProject:Project?
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 5
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        let addNewTask = Task(context: context)
        if taskName.text != "" && taskDescription.text != ""{
            addNewTask.taskName = taskName.text
            addNewTask.taskDescription = taskDescription.text
            addNewTask.taskStartDate = "\(dateFormatter.string(from: stardDatePicker.date))"
            addNewTask.taskEndDate = "\(dateFormatter.string(from: datePicker.date))"
            addNewTask.taskComplete = Float(0)
            
            currentProject?.addToTask(addNewTask)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }else{
            let alert = UIAlertController(title: "Misisng some values", message: "Please enter all required inputs", preferredStyle: .alert)
            let okayaction = UIAlertAction(title: "okay", style: .default, handler: nil)
            alert.addAction(okayaction)
            self.present(alert, animated: true, completion: nil)
        }
    
        if notifySwitch.isOn == true {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "TASKS - Let's manage everything"
            content.subtitle = "\(addNewTask.taskName!)"
            content.body = "Due date of \(addNewTask.taskName!) exceeded."
            content.sound = UNNotificationSound.default()
            content.threadIdentifier = "TASKS notifications temp"
            
            //            let date = Date(timeIntervalSinceNow: 30)
            let date = datePicker.date
            let datecComponents = Calendar.current.dateComponents([.year, .month, .day, . hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: datecComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
            
            center.add(request) { (error) in
                if error != nil {
                    print(error!)
                } else {
                }
            }
        }
        
    }

}
