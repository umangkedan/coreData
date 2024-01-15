//
//  TeacherViewController.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 11/01/24.


import UIKit
import CoreData

class TeacherViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var submitAction: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    var selectedStudents: [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
    }
    
    func setTextFields(){
        firstNameTextField.delegate = self
        courseTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.becomeFirstResponder()
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if let context = appDelegate?.persistentContainer.viewContext {
            guard let firstName = firstNameTextField.text,
                  let lastName = lastNameTextField.text,
                  let course = courseTextField.text else{
                return
            }
            let teacherObject = Teacher(context: context)
            teacherObject.subject = course
            teacherObject.first_name = firstName
            teacherObject.last_name = lastName
            
            
            do {
                try context.save()
                fetchDetails()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchDetails(){
        if let context = appDelegate?.persistentContainer.viewContext{
            let fetchRequest = NSFetchRequest<Teacher>(entityName: "Teacher")
            do {
                let results = try context.fetch(fetchRequest)
                
                for teacher in results {
                    print(teacher.first_name ?? "")
                    print(teacher.last_name ?? "")
                    print(teacher.subject ?? "")
                }
                guard let teacherTableController =  UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "teacherTable") as? TeacherTableViewController else {
                    return
                }
                
                teacherTableController.firstName = firstNameTextField.text
                teacherTableController.lastName = lastNameTextField.text
                teacherTableController.subject = courseTextField.text
                
                self.navigationController?.pushViewController(teacherTableController, animated: true)
                
            }
            catch {
                print(error)
            }
        }
    }
}

extension TeacherViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
