//
//  AppDelegate.swift
//  TaskManager
//
//  Created by Bilal Nawaz on 7/20/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        
        do{
            _ = try Realm()
        }catch{
            print("error initializing realm\(error)")
        }
        
        
        
        return true
    }



}

