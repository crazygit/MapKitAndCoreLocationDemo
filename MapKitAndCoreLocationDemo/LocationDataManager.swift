//
//  LocationDataManager.swift
//  MapKitAndCoreLocationDemo
//
//  Created by Crazygit on 2023/8/1.
//

import Foundation
import CoreLocation


class LocationDataManager : NSObject, CLLocationManagerDelegate {
   var locationManager = CLLocationManager()


   override init() {
      super.init()
      locationManager.delegate = self
   }


    func checkService() {
        if (CLLocationManager.significantLocationChangeMonitoringAvailable())
    }

   // Location-related properties and delegate methods.
}
