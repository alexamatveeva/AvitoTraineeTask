//
//  EmployeesListTableViewCell.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 09.09.2022.
//

import UIKit

class EmployeesListTableViewCell: UITableViewCell {
    
    let stackView = UIStackView()
    
    let employeeNameLabel = UILabel()
    let phoneNumberLabel = UILabel()
    let skillsLabel = UILabel()
    
    static let identifier = "EmployeesListTableViewCell"
    static let rowHeight: CGFloat = 86
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EmployeesListTableViewCell {
    func setup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        
        employeeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        employeeNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        employeeNameLabel.text = "Name"
        employeeNameLabel.textColor = . label
        
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        phoneNumberLabel.text = "phone"
        phoneNumberLabel.textColor = . label
        
        skillsLabel.translatesAutoresizingMaskIntoConstraints = false
        skillsLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        skillsLabel.text = "skills"
        skillsLabel.textColor = . label
    }
    
    func layout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(employeeNameLabel)
        stackView.addArrangedSubview(phoneNumberLabel)
        stackView.addArrangedSubview(skillsLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2)
        ])
    }
}
