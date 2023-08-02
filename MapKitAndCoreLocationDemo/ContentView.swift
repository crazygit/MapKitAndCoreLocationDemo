//
//  ContentView.swift
//  MapKitAndCoreLocationDemo
//
//  Created by Crazygit on 2023/8/1.
//

import MapKit
import os
import SwiftUI

struct ContentView: View {
    let logger = Logger(subsystem: "com.github.crazygit.mapKitAndCoreLocationDemo", category: "DemoView")

    @ObservedObject var locationsHandler = LocationsHandler.shared
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        VStack {
            Spacer()
            Text("Location: \(self.locationsHandler.lastLocation)")
                .padding(10)
            Text("Count: \(self.locationsHandler.count)")
            Text("isStationary:")
            Rectangle()
                .fill(self.locationsHandler.isStationary ? .green : .red)
                .frame(width: 100, height: 100, alignment: .center)
            Spacer()
            Button(self.locationsHandler.updatesStarted ? "Stop Location Updates" : "Start Location Updates") {
                self.locationsHandler.updatesStarted ? self.locationsHandler.stopLocationUpdates() : self.locationsHandler.startLocationUpdates()
            }
            .buttonStyle(.bordered)
            Button(self.locationsHandler.backgroundActivity ? "Stop BG Activity Session" : "Start BG Activity Session") {
                self.locationsHandler.backgroundActivity.toggle()
            }
            .buttonStyle(.bordered)

            Map(position: $position) {
                MapPolyline(coordinates: locationsHandler.trackCoordinates)
                    .stroke(.blue, lineWidth: 13)
                UserAnnotation()
            }
        }
    }
}

#Preview {
    ContentView()
}
