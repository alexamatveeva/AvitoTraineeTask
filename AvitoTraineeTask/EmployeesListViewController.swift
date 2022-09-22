//
//  EmployeesListViewController.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 07.09.2022.
//

import UIKit

class EmployeesListViewController: UIViewController {
    
    var employeesListManager = EmployeesListManager()
    
    var timer = Timer()
    
    var secondsPassed = 0
    
    
    private var employeesList: EmployeesListData?
    //    private var filteredEmployees: [Employee]?
    
//    private var result: Result<EmployeesListData, Error>?
    
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
        
        employeesListManager.delegate = self
        fetchAllData()
        
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
    
    //    func setTimer() {
    //
    //        let totalTime = 20
    //
    //        timer.invalidate()
    //
    //        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
    //            if self.secondsPassed < totalTime {
    //                    self.secondsPassed += 1
    //                print("second passed = \(self.secondsPassed)")
    //                } else {
    //                    Timer.invalidate()
    //                    self.secondsPassed = 0
    ////                    self.employeesListManager.infoCache.removeAllObjects()
    //                    self.employeesListManager.fetchEmployeesListManager() { employeesList in
    //                        self.employeesList = employeesList
    //                    }
    //                    print("time ended")
    //
    //                }
    //            }
    //    }
    
    func fetchAllData() {
        employeesListManager.fetchEmployeesListManager() { result in
            
            switch result {
            case .success(let list):
                self.employeesList = list
                self.updateData(employeesListData: list)
            case .failure(let error):
                self.failWithError(error: error)
            case .none:
                print("non switch")
            }
            
        }
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
    func updateData(employeesListData: EmployeesListData) {
        employeesList = employeesListData
        
        DispatchQueue.main.async {
            self.companyNameLabel.text = self.employeesList?.company.name
            self.tableView.reloadData()
            
        }
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.setTimer()
//        }
        
        
    }
    
    func failWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - UISearchBarDelegate

extension EmployeesListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.searchTextField.text {
            employeesListManager.fetchEmployeesListManager(query: query, completion: { result in
                //            self.result = result
                
                switch result {
                case .success(let list):
                    self.employeesList = list
                    self.updateData(employeesListData: list)
                case .failure(let error):
                    self.failWithError(error: error)
                case .none:
                    print("non switch")
                }
                
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchAllData()
    }
    
    
}
