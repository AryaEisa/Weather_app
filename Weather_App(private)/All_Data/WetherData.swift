//
//  WetherData.swift
//  Weather_App(private)
//
//  Created by Arya Pour Eisa on 2024-01-29.
//

import Foundation
import SwiftUI
import Observation

struct WeatherData: Codable {
    var latitude: Double
    var longitude: Double
    var timezone: String
    var daily: Daily
    var current: Current

}
struct Daily: Codable {
    var time: [String]
    var temperature_2m_max: [Double]
}

struct Current: Codable {
    var time: String
    var temperature_2m: Double
}

struct DailyWeather: Identifiable {
    let id = UUID()
    var day: String
    var maxTemperature: Double
}
