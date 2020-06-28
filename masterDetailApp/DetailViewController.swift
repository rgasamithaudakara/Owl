//
//  DetailViewController.swift
//  Master Detailed App Version 02
//
//  Created by Wagee Ishani on 5/21/19.
//  Copyright © 2019 Wagee Ishani. All rights reserved.

import UIKit
import UserNotifications
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

   
    
    //UI Elements
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectDescriptionLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var editProjectButton: UIButton!
    @IBOutlet weak var circularProgress: CircularProgressView!
    @IBOutlet weak var timeCircularProgress: CircularProgressView!
    @IBOutlet weak var overallProgressLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    
    var progress = Float(0)
    var progressValue = Float(0)
    var index = 0
    var manageObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchRequest: NSFetchRequest<Task>!
    var tasks: [Task]!
    
    func configureView() {
        if let detail = project {
            if let label = projectNameLabel {
                label.text = detail.projectName
            }
            if let label = priorityLabel{
                label.text = detail.projectPriority
            }
            if let label = projectDescriptionLabel{
                label.text = detail.projectDescription
            }
            if let label = deadlineLabel{
                label.text = detail.projectDeadline
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
         timeProgress()
         overallProgress (value: Float(0))
    }
    
    func generateOverallProgress(totalProgress:Float, rows:Int){
        
        if numberOfSections(in: taskTableView) != 0 {
            print(numberOfSections(in: taskTableView))
            print(progress)
            overallProgress(value: progressValue)
            overallProgressLabel.text = "\(Int(round(progressValue*100)))%"
        }
        
        
    }
    
    var project: Project? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    var projectStartDate: Date = Date()
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "addTask"
        {
            if let addTaskViewController = segue.destination as? PopoverViewController
            {
                addTaskViewController.currentProject = project
                
            }
            
        }
                if segue.identifier == "editProject"
                {
                    if let editCourseworkViewController = segue.destination as? EditProjectViewController
                    {
                        editCourseworkViewController.project = project
        
                    }
        
                }
        
        if segue.identifier == "editTask"
        {
            if let taskedit = segue.destination as? EditTaskViewController{
                print("edit task")
                if let indexPath = taskTableView.indexPathForSelectedRow {
                    let object = fetchedResultsController.object(at: indexPath)
                    taskedit.currentTask = object
                }
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    // tableView deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "taskCell") as! taskUITableViewCell
        let task = self.fetchedResultsController.fetchedObjects?[indexPath.row]
        
        cell.taskNameLabel.text = task?.taskName
        cell.taskDescriptionLabel.text = task?.taskDescription
        cell.startDateLabel.text = task?.taskStartDate
        cell.endDateLabel.text = task?.taskEndDate
        cell.taskProgress(value: (task?.taskComplete)!)
        
        index = index + 1
        progress = (progress + (task?.taskComplete)!)
        progressValue = progress / Float(index)
        
        print("progress value = \(progress)")
        generateOverallProgress(totalProgress: progress, rows: index)
        
        return cell
    }
    
    
    func configureCell(_ cell: UITableViewCell,  indexPath: IndexPath) {

        let cell = cell as! taskUITableViewCell
        
        let taskName = self.fetchedResultsController.fetchedObjects?[indexPath.row].taskName
        let taskDescription = self.fetchedResultsController.fetchedObjects?[indexPath.row].taskDescription
        let progress = self.fetchedResultsController.fetchedObjects?[indexPath.row].taskComplete
        let startDate = self.fetchedResultsController.fetchedObjects?[indexPath.row].taskStartDate
        let endDate = self._fetchedResultsController?.fetchedObjects?[indexPath.row].taskEndDate
        print(indexPath)
        print("completed")
        
        
        cell.taskNameLabel.text = taskName
        cell.taskDescriptionLabel.text = taskDescription
        cell.startDateLabel.text = startDate
        cell.endDateLabel.text = endDate
        cell.taskProgress(value: progress!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func overallProgress (value: Float) {
        circularProgress.trackColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        circularProgress.progressColor = UIColor(red: 252.0/255.0, green: 141.0/255.0, blue: 0/255.0, alpha: 1.0)
        circularProgress.setProgressWithAnimation(duration: 1.0, value: value)
        overallProgressLabel.text = "\(Int(round(value * 100)))%"
        
    }
    
    func timeProgress () {
        var value: Float = 0.0
        if deadlineLabel.text != "" {
            
            let startDate = deadlineLabel.text!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let lastDate = dateFormatter.date(from: startDate)
            let currentDate = Date()
            let components = Set<Calendar.Component>([.day])
            let differenceOfDate = Calendar.current.dateComponents(components, from: currentDate, to: lastDate!)
            let timeDuration = Calendar.current.dateComponents(components, from: projectStartDate, to: lastDate!)
            var initialDays = "\(timeDuration)"
            initialDays.removeFirst(5)
            initialDays.removeLast(19)
            if initialDays.contains(" "){
                initialDays.removeLast()
            }
            var days = "\(differenceOfDate)"
            days.removeFirst(5)
            days.removeLast(19)
            if days.contains(" "){
                days.removeLast()
            }
            if Int(initialDays) != nil && Int(initialDays) != 0 {

                value = Float(days)! / Float(initialDays)!
            }
            timeLeftLabel.text = "\(days)"
            print(days)
        } else {
            value = 0.0
            timeLeftLabel.text = "0"
        }
        timeCircularProgress.trackColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        timeCircularProgress.progressColor = UIColor(red: 252.0/255.0, green: 141.0/255.0, blue: 0/255.0, alpha: 1.0)
        timeCircularProgress.setProgressWithAnimation(duration: 1.0, value: value)
    }

    // MARK: - Fetched results controller
    
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Task> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let curretProject = self.project
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Set the batch size to a suitable number.
        request.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let taskNameSortDescriptor = NSSortDescriptor(key: "taskName", ascending: false,selector:#selector(NSString.localizedStandardCompare(_:)))

        request.sortDescriptors = [taskNameSortDescriptor]
        
        if(self.project != nil){
            let predicate = NSPredicate(format:"projectTask = %@",curretProject!)
            request.predicate = predicate
        }else{
            let predicate = NSPredicate(format:"projectTask = %@","")
            request.predicate = predicate
        }

        let frc = NSFetchedResultsController<Task>(
            fetchRequest: request,
            managedObjectContext: manageObjectContext,
            sectionNameKeyPath: #keyPath(Task.projectTask),
            cacheName: nil)
        frc.delegate = self
        _fetchedResultsController = frc
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {

            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return frc as! NSFetchedResultsController<NSFetchRequestResult> as!
            NSFetchedResultsController<Task>
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            taskTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            taskTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            taskTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            taskTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(taskTableView.cellForRow(at: indexPath!)!, indexPath: newIndexPath!)
        case .move:
            taskTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.endUpdates()
    }

}

