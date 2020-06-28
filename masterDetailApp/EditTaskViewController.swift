//
//  EditTaskViewController.swift
//  Master Detailed App Version 02
//
//  Created by Wagee Ishani on 5/21/19.
//  Copyright © 2019 Wagee Ishani. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDescription: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var taskProgress: UISlider!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentTask:Task?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        taskName.text = currentTask?.taskName
        taskDescription.text = currentTask?.taskDescription
        
        if  currentTask?.taskComplete != nil {
            startDate.datePickerMode = UIDatePicker.Mode.date
            endDate.datePickerMode = UIDatePicker.Mode.date
            
            startDate.date = dateFormatter.date(from:(currentTask?.taskStartDate)!)!
            endDate.date = dateFormatter.date(from:(currentTask?.taskEndDate)!)!
            taskProgress.setValue(Float((currentTask?.taskComplete)!), animated: false)
        }
    }
    
    @IBAction func updateTask(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        print(".........................................", taskName.text)
        currentTask?.taskName = taskName.text! + " "
        currentTask?.taskStartDate = "\(dateFormatter.string(from: startDate.date))"
        currentTask?.taskEndDate = "\(dateFormatter.string(from: endDate.date))"
        currentTask?.taskDescription = taskDescription.text
        currentTask?.taskComplete = taskProgress.value
        
         (UIApplication.shared.delegate as! AppDelegate).saveContext()
      
    }

    @IBAction func sliderProgress(_ sender: Any) {
    }
    

}
