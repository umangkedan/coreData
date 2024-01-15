//
//  ViewController.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 11/01/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addRecords()
        fetchRecords()
    }
    
    func addRecords() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            
            let studentObject = Student(context: context)
            studentObject.age = 22
            studentObject.name = "John"
            studentObject.id = UUID()
            studentObject.course = "iOS"
            
            let teacherObject = Teacher(context: context)
            teacherObject.first_name = "Aakash"
            teacherObject.last_name = "Chopra"
            teacherObject.subject = "iOS"
            studentObject.to_teacher = NSSet(object: teacherObject)
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func fetchRecords() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<Student>(entityName: "Student")
            do {
                let results = try context.fetch(fetchRequest)
                
                for student in results {
                    print(student.name ?? "")
                    print(student.id ?? "")
                    
                    if let teachers = student.to_teacher as? Set<Teacher> {
                        for teacher in teachers {
                            print(teacher.first_name ?? "")
                            print(teacher.last_name ?? "")
                            print(teacher.subject ?? "")
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
