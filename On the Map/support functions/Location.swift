//
//  Location.swift
//  On the Map
//
//  Created by fadel sultan on 11/8/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
//
//  Location.swift
//  iHasa
//
//  Created by fadel sultan on 9/17/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


class cLocation : NSObject {
    
    static var x:String = ""
    static var y:String = ""
    
    static var shared = cLocation()
    
    fileprivate var locationManager = CLLocationManager()
    fileprivate var currentLocation: CLLocation?
    
     func start() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
}


// Delegates to handle events for the location manager.
extension cLocation: CLLocationManagerDelegate {
    
    // Handle incoming location events.
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation = locations.last!
    
        cLocation.x = "\(location.coordinate.latitude)"
        cLocation.y = "\(location.coordinate.longitude)"

        
    }
    // Handle authorization for the location manager.
     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
            
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError("")
        }
    }
    
    // Handle location manager errors.
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}

