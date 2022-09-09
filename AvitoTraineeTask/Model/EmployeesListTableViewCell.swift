//
//  EmployeesListTableViewCell.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 09.09.2022.
//

import UIKit

class EmployeesListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    
    static let identifier = "EmployeesListTableViewCell"
    static let nib = UINib(nibName: "EmployeesListTableViewCell", bundle: nil)
    static let rowHeight: CGFloat = 86

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
