//
//  EmployeesListViewController.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 07.09.2022.
//

import UIKit

class EmployeesListViewController: UIViewController {
    
    var employeesListManager = EmployeesListManager()
    var employeesList: EmployeesListData?
    
    let companyNameLabel = UILabel()
    let subtitleLabel = UILabel()
    
    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
    
}

extension EmployeesListViewController {
    func setup() {
        employeesListManager.delegate = self
        employeesListManager.fetchEmployeesListManager()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeesListTableViewCell.nib, forCellReuseIdentifier: EmployeesListTableViewCell.identifier)
        
    }
    
    
    func style() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = EmployeesListTableViewCell.rowHeight
        
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        companyNameLabel.text = "Company"
        companyNameLabel.textColor = .label
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        subtitleLabel.text = "List of employees"
        subtitleLabel.textColor = .label
        
    }
    
    func layout() {
        view.addSubview(companyNameLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            companyNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            companyNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            companyNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: companyNameLabel.bottomAnchor, multiplier: 1),
            subtitleLabel.leadingAnchor.constraint(equalTo: companyNameLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: companyNameLabel.trailingAnchor),
            
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 2),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


//MARK: - UITableViewDelegate

extension EmployeesListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: - UITableViewDataSource

extension EmployeesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let safeEmployeesList = employeesList {
            return safeEmployeesList.company.sortedEmployees.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let safeEmployeesList = employeesList {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmployeesListTableViewCell.identifier, for: indexPath) as! EmployeesListTableViewCell
            cell.employeeNameLabel.text = safeEmployeesList.company.sortedEmployees[indexPath.row].name
            cell.phoneNumberLabel.text = safeEmployeesList.company.sortedEmployees[indexPath.row].phone_number
            cell.skillsLabel.text = safeEmployeesList.company.sortedEmployees[indexPath.row].allSkills
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Нет данных"
            return cell
        }
    }
}

//MARK: - EmployeesListManagerDelegate

extension EmployeesListViewController: EmployeesListManagerDelegate {
    func updateData(_ employeesListManager: EmployeesListManager, employeesListData: EmployeesListData) {
        employeesList = employeesListData
        
        DispatchQueue.main.async {
            self.companyNameLabel.text = self.employeesList?.company.name
            self.tableView.reloadData()
        }
    }
    
    func failWithError(error: Error) {
        print(error)
    }
    
    
}
