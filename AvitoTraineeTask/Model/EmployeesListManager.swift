//
//  EmployeesListManager.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 07.09.2022.
//

import Foundation

protocol EmployeesListManageable: AnyObject {
    func fetchEmployeesList(query: String, completion: @escaping(Result<EmployeesListData, NetworkError>) -> Void)
}

enum NetworkError: Error {
    case serverError
    case decodingError
}

class EmployeesListManager: EmployeesListManageable {
    func fetchEmployeesList(query: String = "", completion: @escaping (Result<EmployeesListData, NetworkError>) -> Void) {
        let url = URL(string: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                
                do {
                    let employeesList = try JSONDecoder().decode(EmployeesListData.self, from: data)
                    if query != "" {
                        var tempListOfEmployee = employeesList.company.employees
                        tempListOfEmployee.removeAll()
                        
                        for employee in employeesList.company.employees {
                            if employee.name.lowercased().contains(query.lowercased()){
                                tempListOfEmployee.append(employee)
                            }
                        }
                        
                        employeesList.company.employees = tempListOfEmployee
                    }
                    completion(.success(employeesList))
                } catch {
                    completion(.failure(.decodingError))
                }

            }
        }.resume()
    }
    
    
}
