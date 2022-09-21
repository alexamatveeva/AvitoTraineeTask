//
//  EmployeesListData.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 07.09.2022.
//

import Foundation

class EmployeesListData: Codable {
    let company: Company
}

class Company: Codable {
    let name: String
    var employees: [Employee]
    
    var sortedEmployees: [Employee] {
        let sortedEmployees = employees.sorted(by: { employee1, employee2 in
            return employee1.name < employee2.name
        })
        
        return sortedEmployees
    }
}

class Employee: Codable {
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

