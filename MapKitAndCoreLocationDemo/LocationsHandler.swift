//
//  LocationsHandler.swift
//  MapKitAndCoreLocationDemo
//
//  Created by Crazygit on 2023/8/1.
//

import CoreLocation
import os

@MainActor class LocationsHandler: NSObject, ObservableObject {
    let logger = Logger(subsystem: "com.apple.liveUpdatesSample", category: "LocationsHandler")

    static let shared = LocationsHandler() // Create a single, shared instance of the object.

    private let manager = CLLocationManager()
    private var background: CLBackgroundActivitySession?

    @Published var lastLocation = CLLocation()
    @Published var count = 0
    @Published var isStationary = false
    @Published var trackCoordinates: [CLLocationCoordinate2D] = []

    @Published
    var updatesStarted: Bool = UserDefaults.standard.bool(forKey: "liveUpdatesStarted") {
        didSet { UserDefaults.standard.set(updatesStarted, forKey: "liveUpdatesStarted") }
    }

    @Published
    var backgroundActivity: Bool = UserDefaults.standard.bool(forKey: "BGActivitySessionStarted") {
        didSet {
            backgroundActivity ? self.background = CLBackgroundActivitySession() : self.background?.invalidate()
            UserDefaults.standard.set(backgroundActivity, forKey: "BGActivitySessionStarted")
        }
    }

    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = false
        manager.allowsBackgroundLocationUpdates = true
        manager.showsBackgroundLocationIndicator = true
    }

    func startLocationUpdates() {
        print("authorizationStatus: \(manager.authorizationStatus)")
        if manager.authorizationStatus == .notDetermined {
            print("requestAlwaysAuthorization")
            // after the user makes a selection and determines the status, the location manager delivers the results to the delegate's locationManager(_:didChangeAuthorization:) method.
            manager.requestWhenInUseAuthorization()
        } else {
            logger.info("Starting location updates")
            Task {
                do {
                    self.updatesStarted = true
                    let updates = CLLocationUpdate.liveUpdates()
                    for try await update in updates {
                        if !self.updatesStarted { break } // End location updates by breaking out of the loop.
                        if let loc = update.location {
                            self.lastLocation = loc
                            self.isStationary = update.isStationary
                            self.count += 1
                            self.logger.info("Location \(self.count): \(self.lastLocation)")
                            trackCoordinates.append(loc.coordinate)
                        }
                    }
                } catch {
                    self.logger.error("Could not start location updates")
                }
            }
        }
    }

    func stopLocationUpdates() {
        logger.info("Stopping location updates")
        updatesStarted = false
    }
}

extension LocationsHandler: CLLocationManagerDelegate {
    // 该方法会在每次初始化locationManager实例或者当前App的定位权限发生变化时触发调用
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("call locationManagerDidChangeAuthorization")
        switch manager.authorizationStatus {
        case .notDetermined:
            // 这里不请求授权，因为在LocationsHandler.startLocationUpdates()中会去申请
//            manager.requestWhenInUseAuthorization()
            print("notDetermined")

        case .restricted:
            print("your location is restricted likely due to parental controls")
        case .denied:
            print("You have denied this app location permission. Go into Settings to enable it")
        case .authorizedAlways, .authorizedWhenInUse:
            /*
             This method returns immediately. Calling this method causes the location manager to obtain an initial location fix (which may take several seconds) and notify your delegate by calling its locationManager(_:didUpdateLocations:) method. After that, the receiver generates update events primarily when the value in the distanceFilter property is exceeded. Updates may be delivered in other situations though. For example, the receiver may send another notification if the hardware gathers a more accurate location reading.
             Calling this method several times in succession does not automatically result in new events being generated. Calling stopUpdatingLocation() in between, however, does cause a new initial event to be sent the next time you call this method.
             If you start this service and your app is suspended, the system stops the delivery of events until your app starts running again (either in the foreground or background). If your app is terminated, the delivery of new location events stops altogether. Therefore, if your app needs to receive location events while in the background, it must include the UIBackgroundModes key (with the location value) in its Info.plist file.
             In addition to your delegate object implementing the locationManager(_:didUpdateLocations:) method, it should also implement the locationManager(_:didFailWithError:) method to respond to potential errors.
             */
            print("startUpdatingLocation")

            // 下面的allowsBackgroundLocationUpdates开启程序一运行就会崩溃
            /// Enable the app to collect location updates while it's in the background.
//            locationManager.allowsBackgroundLocationUpdates = true
            manager.startUpdatingLocation()

        @unknown default:
            print("default")
        }
    }

    // FIXME: 如何处理错误信息
    // Tells the delegate that the location manager was unable to retrieve a location value.
    func locationManager(_: CLLocationManager, didFailWithError _: Error) {}

    // FIXME: 如何处理错误信息
    // Tells the delegate that a region monitoring error occurred.
    func locationManager(_: CLLocationManager, monitoringDidFailFor _: CLRegion?, withError _: Error) {}

//    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        DispatchQueue.main.async {
//        }
//    }

    func locationManagerDidPauseLocationUpdates(_: CLLocationManager) {
        print("locationManagerDidPauseLocationUpdates")
    }

    func locationManagerDidResumeLocationUpdates(_: CLLocationManager) {
        print("locationManagerDidResumeLocationUpdates")
    }
}
