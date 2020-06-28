//
//  Project+CoreDataProperties.swift
//  
//
//  Created by Wagee Ishani on 5/25/19.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var projectName: String?
    @NSManaged public var projectDescription: String?
    @NSManaged public var projectDeadline: String?
    @NSManaged public var projectPriority: String?
    @NSManaged public var projectComplete: Float
    @NSManaged public var projectStartDate: String?
    @NSManaged public var task: NSSet?

}

// MARK: Generated accessors for task
extension Project {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: Task)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}
