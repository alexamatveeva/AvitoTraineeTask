//
//  EmployeesListViewController.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 07.09.2022.
//

import UIKit

class EmployeesListViewController: UIViewController {
    
    var employeesListManager: EmployeesListManageable = EmployeesListManager()
    
    private var employeesList: EmployeesListData?
    
    // Error alert
    lazy var errorAlert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    let searchBar = UISearchBar()
    let companyNameLabel = UILabel()
    
    
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
        fetchData()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeesListTableViewCell.self, forCellReuseIdentifier: EmployeesListTableViewCell.identifier)
        
        
        
    }
    
    
    func style() {
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        companyNameLabel.text = "Company"
        companyNameLabel.textColor = .label
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search employee"
        searchBar.autocapitalizationType = .words
        searchBar.returnKeyType = .search
        searchBar.layer.borderWidth = 1;
        searchBar.layer.borderColor = CGColor(gray: 1, alpha: 1)
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = EmployeesListTableViewCell.rowHeight
        
        
        
    }
    
    func layout() {
        view.addSubview(companyNameLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            companyNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            companyNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: companyNameLabel.trailingAnchor, multiplier: 2),
            
            searchBar.topAnchor.constraint(equalToSystemSpacingBelow: companyNameLabel.bottomAnchor, multiplier: 1),
            searchBar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchBar.trailingAnchor, multiplier: 1),
            
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: searchBar.bottomAnchor, multiplier: 2),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func fetchData(query: String = "") {
        employeesListManager.fetchEmployeesList(query: query) { result in
            switch result {
            case .success(let list):
                self.employeesList = list
                self.updateData()
            case .failure(let error):
                self.displayError(error)
                
            }
            
        }
    }
    
    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }

    private func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        switch error {
        case .serverError:
            title = "Server Error"
            message = "We could not process your request. Please try again."
        case .decodingError:
            title = "Network Error"
            message = "Ensure you are connected to the internet. Please try again."
        }
        return (title, message)
    }
    
    private func showErrorAlert(title: String, message: String) {
        
        errorAlert.title = title
        errorAlert.message = message
        
        present(errorAlert, animated: true, completion: nil)
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

extension EmployeesListViewController {
    
    func updateData() {
        
        guard let list = self.employeesList else { return }
        
        DispatchQueue.main.async {
            self.companyNameLabel.text = list.company.name
            self.tableView.reloadData()
            
        }
        
        
    }
    
    
}

//MARK: - UISearchBarDelegate

extension EmployeesListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.searchTextField.text {
            fetchData(query: query)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let query = searchBar.searchTextField.text {
            fetchData(query: query)
        }
    }
    
    
}
