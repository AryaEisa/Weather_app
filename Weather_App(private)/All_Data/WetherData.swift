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
               formatter.dateFormat = "E-dd MMMM, HH:mm"
               return formatter
           }()
           return dateFormatter.string(from: Date())
       }
    }


struct Daily: Codable {
    var time: [String]
    var weather_code: [Int]
    var temperature_2m_max: [Double]

    func formattedDayOfWeek(forIndex index: Int) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        if let startDate = calendar.date(byAdding: .day, value: index, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E-ddMMMM"
            return dateFormatter.string(from: startDate)
        } else {
            return "Invalid date"
        }
    }
}


struct Current: Codable {
    var time: String
    var temperature_2m: Double
   var weather_code: Int
}



struct DailyWeather: Identifiable {
    let id = UUID()
    var day: String
    var maxTemperature: Double
}

func emojiForWeatherCode(_ code: Int) -> String {

       switch code {

       case 0:

           return "☀️" // Clear sky

       case 1, 2, 3:

           return "🌤️" // Mainly clear, partly cloudy, and overcast

       case 45, 48:

           return "💨" // Fog and depositing rime fog

       case 51, 53, 55:

           return "🌧️" // Drizzle: Light, moderate, and dense intensity

       case 56, 57:

           return "❄️" // Freezing Drizzle: Light and dense intensity

       case 61, 63, 65:

           return "🌧️" // Rain: Slight, moderate and heavy intensity

       case 66, 67:

           return "❄️" // Freezing Rain: Light and heavy intensity

       case 71, 73, 75:

           return "❄️" // Snow fall: Slight, moderate, and heavy intensity

       case 77:

           return "❄️" // Snow grains

       case 80, 81, 82:

           return "🌧️" // Rain showers: Slight, moderate, and violent

       case 85, 86:

           return "❄️" // Snow showers slight and heavy

       case 95:

           return "⛈️" // Thunderstorm: Slight or moderate

       case 96, 99:

           return "⛈️❄️" // Thunderstorm with slight and heavy hail

       default:

           return "❓" // Unknown or unsupported code

       }

   }
