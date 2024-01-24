//
//  ListTeachersController.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 16/01/24.
//

import UIKit
import CoreData

class ListTeachersController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var teachers: [Teacher] = []
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var selectedTeacher: Teacher?
    var students: [Student] = []
    var selectedCellIndex: IndexPath?
    weak var delegate: TeacherSelectionDelegate?
    var selectedStudent : Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
           tableView.register(UINib(nibName: "ListTeacherTableViewCell", bundle: .main), forCellReuseIdentifier: "teacherCell")
           tableView.delegate = self
           tableView.dataSource = self
           setupEditButton()

        if let selectedTeacher = selectedTeacher, 
            ((appDelegate?.persistentContainer.viewContext) != nil) {
                   teachers = [selectedTeacher]
                   tableView.reloadData()
               }
        }

        func setupEditButton() {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
            header.backgroundColor = .cyan
            
            let editButton = UIButton(frame: CGRect(x: tableView.frame.width / 2 - 40, y: 10, width: 80, height: 30))
            editButton.setTitle("Edit", for: .normal)
            editButton.setTitleColor(.black, for: .normal)
            editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            
            header.addSubview(editButton)
            tableView.tableHeaderView = header
        }
        
        @objc func editButtonTapped() {
            print("Edit button tapped!")
            
            let alert = UIAlertController(title: "Select Action", message: "Select What you want to do", preferredStyle: .actionSheet)
            
            let add = UIAlertAction(title: "Add", style: .default) { _ in
                if let teacherTableController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "teacherTable") as? TeacherTableViewController {
                    teacherTableController.delegate = self
                    self.navigationController?.pushViewController(teacherTableController, animated: true)
                }
            }
            
            let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
               
                self.tableView.isEditing = !self.tableView.isEditing
            }
            
            alert.addAction(add)
            alert.addAction(delete)
            present(alert, animated: true)
        }
    }

    extension ListTeachersController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return teachers.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath) as! ListTeacherTableViewCell
                    
                    if indexPath.row < teachers.count {
                        // Display teacher details
                        let teacher = teachers[indexPath.row]
                        let name = "\(teacher.first_name ?? "") \(teacher.last_name ?? "")"
                        cell.setTeacherName(name: name)
                    }
                    
                    return cell
                }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let selectedTeacher = teachers[indexPath.row]
            
            if let studentSet = selectedTeacher.to_student as? Set<Teacher> ,
                !studentSet.isEmpty {
                let studentNames = Array(studentSet).compactMap { "\($0.first_name ?? "") \($0.last_name ?? "")" }
                
                guard let studentListController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "listStudentController") as? ListStudentController else {
                    return
                }
                studentListController.students = studentNames
                self.navigationController?.pushViewController(studentListController, animated: true)
                
                delegate?.didSelectTeacher(selectedTeacher)
                
            }
            else {
                let alert = UIAlertController(title: "No Students", message: "This teacher has no assigned students.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                
                present(alert, animated: true, completion: nil)
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }

        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let context = appDelegate?.persistentContainer.viewContext {
                    let teacherToDelete = teachers[indexPath.row]
                    
                    do {
                        context.delete(teacherToDelete)
                        try context.save()
                        teachers.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        
                    } catch {
                        print("Error saving context after deletion: \(error.localizedDescription)")
                    }
                }
            }
            
        }
    }

extension ListTeachersController: TeacherSelectionDelegate {
    
    func didSelectTeacher(_ teacher: Teacher) {
//        displaySelectedTeacher(teacher)
//            }
//
//            private func displaySelectedTeacher(_ teacher: Teacher) {
//                // Update the local data source and UI
//                teachers.append(teacher)
//                let newIndexPath = IndexPath(row: teachers.count - 1, section: 0)
//                tableView.insertRows(at: [newIndexPath], with: .automatic)
//            }
//        }
        
saveAndDisplayTeacher(teacher)
   }

   private func saveAndDisplayTeacher(_ teacher: Teacher) {
       guard let context = appDelegate?.persistentContainer.viewContext,
             let selectedStudent = selectedStudent else {
           return
       }

       do {

           selectedStudent.addToTo_teacher(teacher)


           try context.save()

           
           teachers.append(teacher)
           let newIndexPath = IndexPath(row: teachers.count - 1, section: 0)
           tableView.insertRows(at: [newIndexPath], with: .automatic)

       } catch {
           print("Error saving context: \(error.localizedDescription)")
           // Handle the error, show an alert, or log it as needed
       }
   }
}
        
