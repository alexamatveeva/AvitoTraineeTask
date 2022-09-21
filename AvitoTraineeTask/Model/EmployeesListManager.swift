//
//  EmployeesListManager.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 07.09.2022.
//

import Foundation

protocol EmployeesListManagerDelegate {
    func updateData(employeesListData: EmployeesListData)
    func failWithError(error: Error)
}

struct EmployeesListManager {
    var delegate: EmployeesListManagerDelegate?
    
    //    var infoCache = NSCache<NSString, Result<EmployeesListData, Error>>()
    
    
    func fetchEmployeesListManager(query: String = "", completion: @escaping(Result<EmployeesListData, Error>?) -> Void) {
        let urlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        
        if let url = URL(string: urlString) {
            let urlSession = URLSession.shared
            let task = urlSession.dataTask(with: url) { data, response, error in
                if error != nil {
                    completion(Result.failure(error!))
//                    self.delegate?.failWithError(error: error!) //Result.fail(error)
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let decodedData = try decoder.decode(EmployeesListData.self, from: safeData)
                        
                        if query != "" {
                            var tempListOfEmployee = decodedData.company.employees
                            tempListOfEmployee.removeAll()
                            
                            for employee in decodedData.company.employees {
                                if employee.name.lowercased().contains(query.lowercased()){
                                    tempListOfEmployee.append(employee)
                                }
                            }
                            
                            decodedData.company.employees = tempListOfEmployee
                        }
                        
                        
                        
                        DispatchQueue.main.async {
                            completion(Result.success(decodedData))
                        }
                    } catch {
                        print(error)
                        //Result.fail(error)
                    }
                }
            }
            
            task.resume()
            
        }
        
        //        if let cachedInfo = infoCache.object(forKey: "employeesListData") {
        //            completion(cachedInfo)
        //            self.delegate?.updateData(employeesListData: cachedInfo) //Result.Success(cachedInfo)
        //            print("cached info loaded")
        //        } else {
        //            if let url = URL(string: urlString) {
        //                let urlSession = URLSession.shared
        //                let task = urlSession.dataTask(with: url) { data, response, error in
        //                    if error != nil {
        //                        self.delegate?.failWithError(error: error!) //Result.fail(error)
        //                        return
        //                    }
        //
        //                    if let safeData = data {
        //                        let decoder = JSONDecoder()
        //
        //                        do {
        //                            let decodedData = try decoder.decode(EmployeesListData.self, from: safeData)
        //                            self.infoCache.setObject(decodedData, forKey: "employeesListData")
        //
        //                            print("decoded data and set cache")
        //                            DispatchQueue.main.async {
        //                                completion(decodedData)//Result.Success(decodedData)
        //                            }
        //                        } catch {
        //                            print(error)
        //                            //Result.fail(error)
        //                        }
        //                    }
        //                }
        //
        //                task.resume()
        //
        //            }
        //        }
        
        
    }
    
    
}
