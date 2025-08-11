//
//  LocationManager.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 11/08/25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var manager = CLLocationManager()
    
    override init() {
        super.init()
        authorizationStatus = manager.authorizationStatus
    }
    
    func checkLocationAuthorization() {
        manager.delegate = self
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access denied/restricted")
            authorizationStatus = manager.authorizationStatus
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location authorized")
            authorizationStatus = manager.authorizationStatus
            manager.startUpdatingLocation()
            lastKnownLocation = manager.location?.coordinate
        default:
            print("Location service disabled")
            authorizationStatus = manager.authorizationStatus
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}
