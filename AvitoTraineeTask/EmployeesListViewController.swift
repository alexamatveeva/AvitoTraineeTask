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
    
    let searchTextField = UISearchTextField()
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
        employeesListManager.fetchEmployeesListManager() { result in
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
            
        }
        
        searchTextField.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeesListTableViewCell.self, forCellReuseIdentifier: EmployeesListTableViewCell.identifier)
        
        
        
    }
    
    
    func style() {
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        companyNameLabel.text = "Company"
        companyNameLabel.textColor = .label
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Search employee"
        searchTextField.autocapitalizationType = .words
        searchTextField.returnKeyType = .search
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = EmployeesListTableViewCell.rowHeight
        
        
        
    }
    
    func layout() {
        view.addSubview(companyNameLabel)
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            companyNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            companyNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: companyNameLabel.trailingAnchor, multiplier: 2),
            
            searchTextField.topAnchor.constraint(equalToSystemSpacingBelow: companyNameLabel.bottomAnchor, multiplier: 1),
            searchTextField.leadingAnchor.constraint(equalTo: companyNameLabel.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: companyNameLabel.trailingAnchor),
            
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: searchTextField.bottomAnchor, multiplier: 2),
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

//MARK: - UITextFieldDelegate

extension EmployeesListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!) //напечатает что там набрал в текст филде, по нажатию кнопки на клавиатуре
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type name of employee"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let query = searchTextField.text {
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
        
        searchTextField.text = ""
        
    }
    
    
}
