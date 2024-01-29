//
//  WeatherView.swift
//  Weather_App(private)
//
//  Created by Arya Pour Eisa on 2024-01-29.
//

import SwiftUI
import WidgetKit

struct WeatherView: View {
    var feedModel: FeedModel = FeedModel()
    var locationManager = LocationManager()

    init() {
        locationManager.feedModel = feedModel
    }
    @State private var isRotating = 0.0
    var body: some View {
        VStack{
            
        NavigationStack {
           
            
                
                List(feedModel.wData, id: \.timezone) { weatherData in
                    
                    let weeklyForecast = weatherData.daily.time.indices.map { index -> DailyWeather in
                                        let isoFormatter = ISO8601DateFormatter()
                                        isoFormatter.formatOptions = [.withFullDate]
                                        let date = isoFormatter.date(from: weatherData.daily.time[index]) ?? Date()
                                        
                                        let dayFormatter = DateFormatter()
                                        // Formaterar datumet till "29 Jan"
                                        dayFormatter.dateFormat = "d MMM"
                                        let dayString = dayFormatter.string(from: date)
                                        
                                        let weekdayFormatter = DateFormatter()
                                        // Hämtar veckodagen, t.ex. "Monday"
                                        weekdayFormatter.dateFormat = "EEEE"
                                        let weekdayString = weekdayFormatter.string(from: date)
                                        
                                        return DailyWeather(day: "\(dayString)\n\(weekdayString)", maxTemperature: weatherData.daily.temperature_2m_max[index])
                                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        HStack{
                            Text("Time Zone: ").bold().foregroundColor(.white)
                            Text(weatherData.timezone).foregroundColor(.white)
                            
                        }
                        
                        HStack {
                            Text("City: ").font(.headline).bold().foregroundColor(.white)
                            Text(locationManager.cityname).foregroundColor(.white)
                        }
                        
                        HStack{
                            Text("Time: ").bold().foregroundColor(.white)
                            Text("\(weatherData.current.time)").foregroundColor(.white)
                            
                        }
                        
                        HStack{
                            Text("Temperature: ").bold().foregroundColor(.white)
                            Text("\(String(format: "%.1f", weatherData.current.temperature_2m)) °C").foregroundColor(.white)
                        }
                        
                    }.listRowBackground(Color.clear)
                        .shadow(color: .red, radius: 1, x:2, y:2)
                    
                    
                    Text("7-days forecast").listRowBackground(Color.clear).bold().font(.largeTitle).foregroundColor(.white)
                    
                    
                    TabView {
                        
                        
                        
                        ForEach(weeklyForecast) { forecast in
                            
                            
                            
                            HStack(alignment: .center) {
                                Text(forecast.day.components(separatedBy: "\n").last ?? "")
                                .foregroundColor(.white)
                                Spacer()
                                Text(String(format: "%.1f°C", forecast.maxTemperature))
                                .foregroundColor(.white)
                                Spacer()
                                Text(forecast.day.components(separatedBy: "\n").first ?? "")
                                .foregroundColor(.white)
                                
                                
                            }
                            .padding()
                        }
                        
                        
                        
                    }.shadow(color: .red ,radius: 3, x: 2, y:20)
                    .listRowBackground(Color.clear)
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 100)
                    
                    
                    
                    
                }
                .listStyle(PlainListStyle())
                .toolbar{
                    ToolbarItem(placement: .principal){
                        VStack{
                            Spacer().padding()
                            HStack{
                                
                                Image(.globe)
                                    
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .rotationEffect(.degrees(isRotating))
                                    .colorMultiply(.blue)
                            }.listRowBackground(Color.clear).padding()
                                
                                .onAppear{
                                withAnimation(.linear(duration: 0.5)
                                    .speed(0.01).repeatForever(autoreverses: false)){
                                        isRotating = 360.0
                                    }
                            }
                        }.shadow(color: .red ,radius: 90, x: 20, y:20)
                    }
                }
                
                
                .onAppear {
                    Task {
                        locationManager.requestLocation()
                        // Lägg till logik här för att välja vilken temperatur som ska sparas
                        if let firstWeatherData = feedModel.wData.first {
                            let userDefaults = UserDefaults(suiteName: "group.by.temp")
                            let temp: Double = firstWeatherData.current.temperature_2m
                            userDefaults?.set(temp, forKey: "currentTemp")
                            WidgetCenter.shared.reloadAllTimelines()
                            }
                        
                        }
                    }.background{
                        Image(.background)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: 10000, height: 1000)
                            .colorMultiply(.blue)
                    }
                }
            }
        }
    }







#Preview {
    WeatherView()
}
