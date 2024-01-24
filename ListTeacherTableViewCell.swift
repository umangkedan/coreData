//
//  ListTeacherTableViewCell.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 23/01/24.
//

import UIKit

class ListTeacherTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
   func setTeacherName(name : String?){
        nameLabel.text = name
    }
    
}
