//
//  Teacher+CoreDataProperties.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 15/01/24.
//
//

import Foundation
import CoreData


extension Teacher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teacher> {
        return NSFetchRequest<Teacher>(entityName: "Teacher")
    }

    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var subject: String?
    @NSManaged public var to_student: NSSet?

}

// MARK: Generated accessors for to_student
extension Teacher {

    @objc(addTo_studentObject:)
    @NSManaged public func addToTo_student(_ value: Student)

    @objc(removeTo_studentObject:)
    @NSManaged public func removeFromTo_student(_ value: Student)

    @objc(addTo_student:)
    @NSManaged public func addToTo_student(_ values: NSSet)

    @objc(removeTo_student:)
    @NSManaged public func removeFromTo_student(_ values: NSSet)

}

extension Teacher : Identifiable {
    static func fetchTeacherRecords(context: NSManagedObjectContext) -> [Teacher] {
        let fetchRequest: NSFetchRequest<Teacher> = Teacher.fetchRequest()

        do {
            let teacher = try context.fetch(fetchRequest)
            return teacher
        } catch {
            print("Error fetching student records: \(error)")
            return []
        }
    }
}
