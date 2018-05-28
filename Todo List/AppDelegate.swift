//
//  AppDelegate.swift
//  Todo List
//
//  Created by Ali Furkan Budak on 20/05/2018.
//  Copyright © 2018 Ali Furkan Budak. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        do{
            _ = try Realm()
        }catch{
            print("Error while initializing realm \(error)")
        }
        return true
    }
}

