//
//  AppDelegate.swift
//  MapKitAndCoreLocationDemo
//
//  Created by Crazygit on 2023/8/1.
//

import os
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    let logger = Logger(subsystem: "com.github.crazygit.mapKitAndCoreLocationDemo", category: "AppDelegate")

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let locationsHandler = LocationsHandler.shared

        // If location updates were previously active, restart them after the background launch.
        if locationsHandler.updatesStarted {
            logger.info("Restart liveUpdates Session")
            locationsHandler.startLocationUpdates()
        }
        // If a background activity session was previously active, reinstantiate it after the background launch.
        if locationsHandler.backgroundActivity {
            logger.info("Reinstantiate background activity session")
            locationsHandler.backgroundActivity = true
        }
        return true
    }
}
