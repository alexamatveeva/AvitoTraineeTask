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
    
    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

extension EmployeesListViewController {
    func setup() {
        employeesListManager.delegate = self
        employeesListManager.fetchEmployeesListManager()
        setupTableView()
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        let cell = UITableViewCell()
        
        if let safeEmployeesList = employeesList {
            cell.textLabel?.text = safeEmployeesList.company.sortedEmployees[indexPath.row].name
            return cell
        } else {
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
            self.tableView.reloadData()
        }
    }
    
    func failWithError(error: Error) {
        print(error)
    }
    
    
}
