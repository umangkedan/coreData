//
//  Department+CoreDataProperties.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 15/01/24.
//
//

import Foundation
import CoreData


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        return NSFetchRequest<Department>(entityName: "Department")
    }

    @NSManaged public var name: String?

}

extension Department : Identifiable {

}
