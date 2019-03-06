//
//  AppDelegate.swift
//  OnTheMapTourist
//
//  Created by Abdulaziz Alsaloum on 03/03/2019.
//  Copyright © 2019 Abdulaziz Alsaloum. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataController = DataController(modelName: "OnTheMapTourist")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVc = MapViewController()
        let navigationController = UINavigationController(rootViewController: mainVc)
//        let mainVc = PhotoAlbumCollectionViewController(collectionViewLayout: ColumnFlowLayout())
//        let navigationController = UINavigationController(rootViewController: mainVc)
        navigationController.navigationBar.isTranslucent = false
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) { }//self.saveContext() }
    
    func applicationWillTerminate(_ application: UIApplication) { }//self.saveContext() }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if dataController.viewContext.hasChanges {
            try? dataController.viewContext.save()
        }
    }
}
