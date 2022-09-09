//
//  EmployeesListManager.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 07.09.2022.
//

import Foundation

protocol EmployeesListManagerDelegate {
    func updateData(_ employeesListManager: EmployeesListManager, employeesListData: EmployeesListData)
    func failWithError(error: Error)
}

struct EmployeesListManager {
    var delegate: EmployeesListManagerDelegate?
    
    
    func fetchEmployeesListManager() {
        let urlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.failWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let decodedData = try decoder.decode(EmployeesListData.self, from: safeData)
                        self.delegate?.updateData(self, employeesListData: decodedData)
                    } catch {
                        print(error)
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    func sortEmployees(employeesArray: [Employee]) -> [Employee] {
        let sortedEmployees = employeesArray.sorted(by: { employee1, employee2 in
            return employee1.name < employee2.name
        })
        
        return sortedEmployees
    }
    
}
