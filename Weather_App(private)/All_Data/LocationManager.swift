//
//  LocationManager.swift
//  Weather_App(private)
//
//  Created by Arya Pour Eisa on 2024-01-29.
//test

import Foundation
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    var location: CLLocation?
    var adress: CLPlacemark?
    var feedModel: FeedModel?
    var cityname = ""
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
    }
    func reverseGeocodeLocation(_ location: CLLocation){
        Task{
            let placemarks = try? await geocoder.reverseGeocodeLocation(location)
            adress = placemarks?.last
            self.cityname = self.adress?.locality ?? "unknown"
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus != .denied {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        if let location {
            reverseGeocodeLocation(location)
            Task{
                await feedModel?.loadFeed(lat: location.coordinate.latitude, long: location.coordinate.longitude)
                print("location manager has new data delivered")
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                print("Platsen är för tillfället okänd, väntar på uppdatering...")
            default:
                print("Oväntat platsfel: \(clError.localizedDescription)")
            }
        } else {
            print("Okänt fel: \(error.localizedDescription)")
        }
    }

}


