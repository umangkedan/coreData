//
//  ListStudentCell.swift
//  CoreDataObjectDemo
//
//  Created by Umang Kedan on 23/01/24.
//

import UIKit

class ListStudentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setName(name : String?){
        nameLabel.text = name
    }
    
}
