//
//  TeacherTableViewController.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 11/01/24.
//

import UIKit
import CoreData

protocol TeacherSelectionDelegate: AnyObject {
    func didSelectTeacher(_ teacher: Teacher )
}

class TeacherTableViewController: UIViewController {
    
    var users : [Teacher] = []
   
    @IBOutlet weak var tabelView: UITableView!
    
    var firstName : String?
    var lastName : String?
    var subject : String?
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var delegate: TeacherSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.register(UINib(nibName: "TeacherTableViewCell", bundle: .main), forCellReuseIdentifier: "teacherCell")
        tabelView.dataSource = self
        tabelView.delegate = self
        fetchStudentRecords()
        setUpLayout()
    }
    
    func setUpLayout(){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tabelView.frame.width, height: 50))
        headerView.backgroundColor = .orange
        
        let addButton = UIButton(frame: CGRect(x: 145 , y: 0, width: 100, height: 50))
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        headerView.addSubview(addButton)
        
        tabelView.tableHeaderView = headerView
    }
    
    @objc func addButtonTapped() {
        guard let addStudentController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "teacher") as? TeacherViewController else {
            return
        }
        self.navigationController?.pushViewController(addStudentController, animated: true)
    }
    
    func fetchStudentRecords() {
            if let context = appDelegate?.persistentContainer.viewContext {
                users = Teacher.fetchTeacherRecords(context: context)
                tabelView.reloadData()
            }
        }
}

extension TeacherTableViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath) as! TeacherTableViewCell
        let teacher = users[indexPath.row]
        
        cell.setCellDataTeacher(firstName: teacher.first_name, lastName: teacher.last_name, subject: teacher.subject)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTeacher = users[indexPath.row]
            
        if let studentSet = selectedTeacher.to_student as? Set<Student>,
           !studentSet.isEmpty {
               let studentNames = Array(studentSet).compactMap { $0.name }
                
                guard let studentListController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "listStudentController") as? ListStudentController else {
                    return
                }
                studentListController.students = studentNames
                self.navigationController?.pushViewController(studentListController, animated: true)
                delegate?.didSelectTeacher(selectedTeacher)
            } else {
                let alert = UIAlertController(title: "No Students", message: "This teacher has no assigned students.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
        }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let context = appDelegate?.persistentContainer.viewContext {
                let studentToDelete = users[indexPath.row]
                context.delete(studentToDelete)
                do {
                    try context.save()
                    users.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch {
                    print("Error deleting object: \(error.localizedDescription)")
                }
            }
        }
    }
}
