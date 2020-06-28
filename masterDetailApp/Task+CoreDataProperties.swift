//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Wagee Ishani on 5/26/19.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskName: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskStartDate: String?
    @NSManaged public var taskEndDate: String?
    @NSManaged public var taskComplete: Float
    @NSManaged public var projectTask: Project?

}
