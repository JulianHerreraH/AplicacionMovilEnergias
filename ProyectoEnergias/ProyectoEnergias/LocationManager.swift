//
//  LocationManager.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/19/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//


import Foundation
import CoreLocation


class LocationManager: NSObject {
    
    
    private let locationManager = CLLocationManager()
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
}


// MARK: - Core Location Delegate
extension LocationManager: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .notDetermined         : print("notDetermined")        // location permission not asked for yet
        case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
        case .authorizedAlways      : print("authorizedAlways")     // location authorized
        case .restricted            : print("restricted")           // TODO: handle
        case .denied                : print("denied")               // TODO: handle
        }
    }
}
