//
//  WeatherData.swift
//  weatherApp.swift
//
//  Created by Arya Pour Eisa on 2024-01-24.
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
    var formattedTime: String {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.dateFormat = "E dd MMMM"
            return formatter
        }()
            return dateFormatter.string(from: Date())
        }
    }


struct Daily: Codable {

    var time: [String]
    var temperature_2m_max: [Double]
    func formattedDayofWeek(forIndex index: Int) -> String{
            let calendar = Calendar.current
            let currentDate = Date()
            if let startDate = calendar.date(byAdding: .day, value: index , to: currentDate){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E"
                return dateFormatter.string(from: startDate)
            }else {
                return "Invalid date "
            }
        }
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


