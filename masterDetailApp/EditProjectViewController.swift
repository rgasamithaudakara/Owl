//
//  EditProjectViewController.swift
//  Master Detailed App Version 02
//
//  Created by Wagee Ishani on 5/21/19.
//  Copyright © 2019 Wagee Ishani. All rights reserved.

import UIKit

class EditProjectViewController: UIViewController {
    
    var newProjectPriority = "Low"

    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var projectDescription: UITextField!
    @IBOutlet weak var prioritySegmentControl: UISegmentedControl!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    
    var project: Project?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func getProjectPriority(_ sender: Any) {
        
        if prioritySegmentControl.selectedSegmentIndex == 0 {
            newProjectPriority = "Low"
        } else if prioritySegmentControl.selectedSegmentIndex == 1 {
            newProjectPriority = "Medium"
        } else if prioritySegmentControl.selectedSegmentIndex == 2 {
            newProjectPriority = "High"
        }
    }
    
    @IBAction func updateProject(_ sender: Any) {
        
        deadlinePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        project?.projectName = projectName.text
        project?.projectDescription = projectDescription.text
        project?.projectPriority = newProjectPriority
        project?.projectDeadline = "\(dateFormatter.string(from: deadlinePicker.date))"
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        // Do any additional setup after loading the view.
        if (project != nil){
            projectName.text = project?.projectName
            projectDescription.text = project?.projectDescription
            
            if project?.projectPriority == "Low"{
                prioritySegmentControl.selectedSegmentIndex = 0
            } else if project?.projectPriority == "Medium"{
                prioritySegmentControl.selectedSegmentIndex = 1
            } else if project?.projectPriority == "High"{
                prioritySegmentControl.selectedSegmentIndex = 2
            }
            deadlinePicker.date = dateFormatter.date(from:(project?.projectDeadline)!)!
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
