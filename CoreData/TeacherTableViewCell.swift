//
//  TeacherTableViewCell.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 11/01/24.
//

import UIKit

class TeacherTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectlabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func setCellDataTeacher(firstName : String? , lastName : String? , subject : String?){
        nameLabel.text = " \(firstName ?? "")  \(lastName ?? "")"
        subjectlabel.text = subject
    }
    
}
