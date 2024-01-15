//
//  StudentTableViewCell.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 11/01/24.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var courceLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setCellData(name: String?, teachers: [String], age: Int, id: UUID) {
           nameLabel.text = name ?? "No Name"
           ageLabel.text = "\(age)"
           courceLabel.text = teachers.joined(separator: ", ")
           idLabel.text = "\(id)"
       }
   }

