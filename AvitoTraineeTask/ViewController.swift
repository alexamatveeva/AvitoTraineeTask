//
//  ViewController.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 07.09.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let decodedData = try decoder.decode(EmployeesListData.self, from: safeData)
                        print(decodedData)
                    } catch {
                        print(error)
                    }
                }
            }
            
            task.resume()
            
        }
    }


}

