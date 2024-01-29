//
//  WeatherClass.swift
//  Weather_App(private)
//
//  Created by Arya Pour Eisa on 2024-01-29.
//

import Foundation
import SwiftUI
import Observation
import WidgetKit


@Observable
class FeedModel {
    var wData: [WeatherData] = []
    var isLoading = false

    func loadFeed(lat: Double, long: Double) async {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(long)&current=temperature_2m&daily=temperature_2m_max") else {
            return
        }
        isLoading = true
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
            DispatchQueue.main.async {
                self.wData = [decodedData]
                if let temp = self.wData.first?.current.temperature_2m {
                    let userDefaults = UserDefaults(suiteName: "group.by.temp")
                    userDefaults?.set(temp, forKey: "currentTemp")
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }

}

