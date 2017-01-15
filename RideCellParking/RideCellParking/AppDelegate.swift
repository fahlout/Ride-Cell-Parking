//
//  AppDelegate.swift
//  RideCellParking
//
//  Created by Niklas Fahl on 1/14/17.
//  Copyright © 2017 Niklas Fahl. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = getTabBarController()
        
        window?.makeKeyAndVisible()
        
        Fabric.with([Crashlytics.self])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate {
    // MARK: - Tab Bar Setup
    func getTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .rideCellBlue
        
        // Parking Location Search Controller
        let parkingLocationSearchVC = ParkingLocationSearchViewController(nibName: "ParkingLocationSearchViewController", bundle: nil)
        let parkingLocationSearchNC = RideCellNavigationController(rootViewController: parkingLocationSearchVC)
        
        // Reservation Controller
        let reservationVC = ReservationTableViewController(nibName: "ReservationTableViewController", bundle: nil)
        let reservationNC = RideCellNavigationController(rootViewController: reservationVC)
        
        // My Car Controller
        let myCarVC = MyCarTableViewController(nibName: "MyCarTableViewController", bundle: nil)
        let myCarNC = RideCellNavigationController(rootViewController: myCarVC)
        
        // Add to tab bar
        tabBarController.viewControllers = [parkingLocationSearchNC, reservationNC, myCarNC]
        
        return tabBarController
    }
}
