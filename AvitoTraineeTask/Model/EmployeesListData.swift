//
//  EmployeesListData.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 07.09.2022.
//

import Foundation

struct EmployeesListData: Codable {
    var company: Company
}

struct Company: Codable {
    let name: String
    var employees: [Employee]
    
    var sortedEmployees: [Employee] {
        let sortedEmployees = employees.sorted(by: { employee1, employee2 in
            return employee1.name < employee2.name
        })
        
        return sortedEmployees
    }
}

struct Employee: Codable {
    let name: String
    let phone_number: String
    let skills: [String]
    
    var allSkills: String {
        var skillsString = ""
        
        for i in skills {
            if i == skills[0] {
                skillsString = skillsString + "" + i
            } else {
                skillsString = skillsString + ", " + i
            }
            
        }
        
        return skillsString
    }
}


class EmployeesListDataObject {
    let employeesList: EmployeesListData
    
    init(employeesList: EmployeesListData) { self.employeesList = employeesList }
}
