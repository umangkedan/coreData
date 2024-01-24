//
//  ListStudentController.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 23/01/24.
//

import UIKit

class ListStudentController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var teachers: [Teacher] = []
        var appDelegate = UIApplication.shared.delegate as? AppDelegate
        var selectedStudents: Student?
        var students: [String] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.register(UINib(nibName: "ListStudentCell", bundle: .main), forCellReuseIdentifier: "listStudent")
            tableView.delegate = self
            tableView.dataSource = self
            
            if let selectedStudent = selectedStudents,
               ((appDelegate?.persistentContainer.viewContext) != nil) {
                students = [selectedStudent.name ?? ""]
                if let teacherSet = selectedStudent.to_teacher as? Set<Teacher> {
                    teachers = Array(teacherSet)
                } else {
                    teachers = []
                }
                tableView.reloadData()
            }
        }
    }

extension ListStudentController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count + students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listStudent", for: indexPath) as! ListStudentCell
        
        if indexPath.row < students.count {
            // Display student data
            let student = students[indexPath.row]
            cell.setName(name: student)
        } else {
            if let teacher = teachers[safe: indexPath.row - students.count] {
                cell.setName(name: teacher.first_name)
            }
        }
        
        return cell
    }
}
extension Collection {
    // Safe subscript to prevent index out of bounds crashes
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

