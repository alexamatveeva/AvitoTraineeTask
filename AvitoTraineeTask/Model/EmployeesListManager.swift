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
    let cache = NSCache<NSString, EmployeesListDataObject>()
    var lastUpdateTime: NSDate?
    var timeInterval: TimeInterval = 0
    
    func fetchEmployeesList(query: String = "", completion: @escaping (Result<EmployeesListData, NetworkError>) -> Void) {
        
        if timePassed() {
            let url = URL(string: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c")!
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        completion(.failure(.serverError))
                        return
                    }
                    
                    do {
                        var employeesList = try JSONDecoder().decode(EmployeesListData.self, from: data)
                        let employeesListObject = EmployeesListDataObject(employeesList: employeesList)
                        self.lastUpdateTime = NSDate()
                        self.cache.setObject(employeesListObject, forKey: "cashedList")
                        
                        if query != "" {
                            employeesList.company.employees = self.searchDataWithQuery(query, from: employeesList.company.employees)
                        }
                        
                        completion(.success(employeesList))
                        print("new request")
                    } catch {
                        completion(.failure(.decodingError))
                    }
                    
                }
            }.resume()
        } else if let cachedList = cache.object(forKey: "cashedList") {
            if query != "" {
                var tempList = cachedList.employeesList
                tempList.company.employees = searchDataWithQuery(query, from: cachedList.employeesList.company.employees)
                completion(.success(tempList))
            } else {
                completion(.success(cachedList.employeesList))
            }
            
        }
        
        
    }
    
    func searchDataWithQuery(_ query: String, from employeesList: [Employee]) -> [Employee] {
        
        var tempListOfEmployee = [Employee]()
        //tempListOfEmployee.removeAll()
        
        for employee in employeesList {
            if employee.name.lowercased().contains(query.lowercased()){
                tempListOfEmployee.append(employee)
            }
        }
        
        return tempListOfEmployee
    }
    
    
    func timePassed() -> Bool {
        guard let safeLastUpdateTime = lastUpdateTime else {
            return true
        }
        timeInterval = safeLastUpdateTime.timeIntervalSinceNow
        
        if timeInterval >=  -100 {
            return false
        } else {
            return true
        }
    
    }
}
