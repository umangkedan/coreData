//
//  Student+CoreDataProperties.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 15/01/24.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var age: Int16
    @NSManaged public var course: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var to_teacher: NSSet?

}

// MARK: Generated accessors for to_teacher
extension Student {

    @objc(addTo_teacherObject:)
    @NSManaged public func addToTo_teacher(_ value: Teacher)

    @objc(removeTo_teacherObject:)
    @NSManaged public func removeFromTo_teacher(_ value: Teacher)

    @objc(addTo_teacher:)
    @NSManaged public func addToTo_teacher(_ values: NSSet)

    @objc(removeTo_teacher:)
    @NSManaged public func removeFromTo_teacher(_ values: NSSet)

}

extension Student : Identifiable {
    static func fetchStudentRecords(context: NSManagedObjectContext) -> [Student] {
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        do {
            let students = try context.fetch(fetchRequest)
            return students
        } catch {
            print("Error fetching student records: \(error)")
            return []
        }
    }
}
