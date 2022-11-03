//
//  AppDelegate.swift
//  AvitoTraineeTask
//
//  Created by Alexandra on 07.09.2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        do {
            let realm = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        window?.rootViewController = EmployeesListViewController()
        
        return true
    }

}

