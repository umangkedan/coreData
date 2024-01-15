//
//  StudentTableViewController.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 11/01/24.
//

import UIKit
import CoreData

class StudentTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var name : String?
    var age : Int16?
    var course : String?
    let cellUUID = UUID()
    
    var users : [Student] = []
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCell()
        setUpLayout()
        fetchStudentRecords()
    }
    
    func setUpCell(){
        tableView.register(UINib(nibName: "StudentTableViewCell", bundle: .main), forCellReuseIdentifier: "studentCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func setUpLayout(){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .orange
        
        let addButton = UIButton(frame: CGRect(x: 145 , y: 0, width: 100, height: 50))
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        headerView.addSubview(addButton)
        
        tableView.tableHeaderView = headerView
    }
    
    @objc func addButtonTapped() {
        guard let addStudentController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "studentViewController") as? StudentViewController else {
            return
        }
        self.navigationController?.pushViewController(addStudentController, animated: true)
    }
    
    func fetchStudentRecords() {
            if let context = appDelegate?.persistentContainer.viewContext {
                users = Student.fetchStudentRecords(context: context)
                tableView.reloadData()
            }
        }
}

extension StudentTableViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! StudentTableViewCell
        let student = users[indexPath.row]

           if let teachersSet = student.to_teacher as? Set<Teacher>,
              let teacher = teachersSet.first {
               cell.setCellData(name: student.name, teachers: ["\(teacher.first_name ?? "") \(teacher.last_name ?? "")"], age: Int(student.age), id: student.id ?? UUID())
           } else {
               cell.setCellData(name: student.name, teachers: [], age: Int(student.age), id: student.id ?? UUID())
           }
           return cell
       }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let student = users[indexPath.row]
           
           if let teachersSet = student.to_teacher as? Set<Teacher>, !teachersSet.isEmpty {
               let teacherNames = teachersSet.map { "\($0.first_name ?? "") \($0.last_name ?? "")" }
               let teachersList = teacherNames.joined(separator: "\n")
               
               let alert = UIAlertController(title: "Teachers", message: teachersList, preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alert.addAction(okAction)
               
               present(alert, animated: true, completion: nil)
               
           } else 
        {
               let alert = UIAlertController(title: "No Teachers", message: "This student has no assigned teachers.", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alert.addAction(okAction)
               
               present(alert, animated: true, completion: nil)
           }
           
           tableView.deselectRow(at: indexPath, animated: true)
       }
   }


