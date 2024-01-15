//
//  StudentViewController.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 11/01/24.
//

import UIKit
import CoreData

class StudentViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var selectTeacherButton: UIButton!
    @IBOutlet weak var teacherTextField: UITextField!
    @IBOutlet weak var courceTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var selectedTeachers: [Teacher] = []
   
    var students: [Student]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageTextField.delegate = self
        nameTextField.delegate = self
        courceTextField.delegate = self
        nameTextField.becomeFirstResponder()
        tapGEsture()
    }

    func validateData() -> Bool {
        
        guard let name = nameTextField.text, name.count > 0 else {
            let alert = UIAlertController(title: "Enter Name", message: "Fill the Name Field", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Okay", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
            return false
        }
        
        guard let age = ageTextField.text, age.count > 0 else {
            let alert = UIAlertController(title: "Enter Age", message: "Fill the Age Field", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Okay", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
            return false
        }
        
        guard Int16(age) != nil else {
            let alert = UIAlertController(title: "Enter Name", message: "Fill the age Field", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Okay", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
            return false
        }
        
        guard let id = idTextField.text, id.count > 0 else {
            return false
        }
        
        guard let course = courceTextField.text, course.count > 0 else {
            let alert = UIAlertController(title: "Enter Course", message: "Fill the Course Field", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Okay", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
            return false
        }
        
        guard selectedTeachers != nil else {
            let alert = UIAlertController(title: "Select Teacher", message: "Select the teacher", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Okay", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
            return false
        }
        
        return true
    }
    
    func tapGEsture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture: )))
        teacherTextField.addGestureRecognizer(tap)
    }
    
    @objc func tapGesture(gesture: UITapGestureRecognizer){
        guard let teacherTableController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "teacherTable") as? TeacherTableViewController else { return }
        teacherTableController.delegate = self
        navigationController?.pushViewController(teacherTableController, animated: true)
    }
    
    @IBAction func teacherSelectAction(_ sender: Any) {
        guard let teacherTableController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "teacherTable") as? TeacherTableViewController else { return }
        teacherTableController.delegate = self
        navigationController?.pushViewController(teacherTableController, animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        guard validateData() else {
            print("Validation Failed")
            
            return
        }
        
        if let context = appDelegate?.persistentContainer.viewContext {
            let studentObject = Student(context: context)
            studentObject.age = Int16(ageTextField.text ?? "0") ?? 0
            studentObject.course = courceTextField.text ?? ""
            studentObject.name = nameTextField.text ?? ""
            studentObject.id = UUID(uuidString: idTextField.text ?? "")
            studentObject.gender = "Female"
            
            if !selectedTeachers.isEmpty {
                studentObject.addToTo_teacher(NSSet(array: selectedTeachers))
            }
            
            do {
                try context.save()
                fetchRecords()
                ageTextField.text = ""
                courceTextField.text = ""
                nameTextField.text = ""
                idTextField.text = ""
                teacherTextField.text = ""
                nameTextField.becomeFirstResponder()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchRecords() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Student>(entityName: "Student")
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for student in results {
                print("Name: \(student.name ?? "")")
                print("Course: \(student.course ?? "")")
                print("Age: \(student.age)")
                print("Gender: \(student.gender ?? "")")
            }
            
            guard let studentTableController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "studentTable") as? StudentTableViewController else { return  }
           
            self.navigationController?.pushViewController(studentTableController, animated: true)
        } catch {
            print("Error fetching records: \(error.localizedDescription)")
        }
    }

}

extension StudentViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension StudentViewController: TeacherSelectionDelegate {
    func didSelectTeacher(_ teacher: Teacher) {
            selectedTeachers.append(teacher)
            updateTeacherTextField()
        }
        
        private func updateTeacherTextField() {
            let teacherNames = selectedTeachers.map { "\($0.first_name ?? "") \($0.last_name ?? "")" }
            teacherTextField.text = teacherNames.joined(separator: ", ")
        }
}


