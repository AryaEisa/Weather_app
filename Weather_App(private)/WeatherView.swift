//
//  WeatherView.swift
//  weatherApp.swift
//
//  Created by Arya Pour Eisa on 2024-01-25.
//

import SwiftUI
import WidgetKit
import MapKit




struct WeatherView: View {
    var feedModel: FeedModel = FeedModel()
    var locationManager = LocationManager()
    @State private var locationService = LocationManager()
    private var ffeedModel = FeedModel()
   
    
    init() {
        locationManager.feedModel = feedModel
    }
    @State private var isRotating = 0.0
    var body: some View {
            NavigationStack {
            VStack{
                List(feedModel.wData, id: \.timezone) { weatherData in
                    HStack(alignment: .center, spacing: 2){
                        Text("Time Zone: ").bold().foregroundColor(.black)
                        Text(weatherData.timezone).foregroundColor(.black).padding()
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        HStack{
                            Text("Time: ").bold().foregroundColor(.black)
                            Text(weatherData.formattedTime)
                        }
                        
                        HStack {
                            Text("City: ").font(.headline).bold().foregroundColor(.black)
                            Text(locationManager.cityname).foregroundColor(.black)
                        }
                        
                        HStack{
                            Text("Temperature: ").bold().foregroundColor(.black)
                            Text("\(String(format: "%.1f", weatherData.current.temperature_2m)) °C").foregroundColor(.black)
                        }
                    }.listRowBackground(Color.clear)
                       
                    Text("7-days forecast").listRowBackground(Color.clear).bold().font(.largeTitle).foregroundColor(.black)
                    
                        TabView {
                            ForEach(0..<7) { index in
                                
                                HStack {
                                    
                                    Text(weatherData.daily.formattedDayofWeek(forIndex: index))
                                    Spacer()
                                    Text("\(weatherData.daily.temperature_2m_max[index], specifier: "%.1f")°C")
                                    
                                }.listRowBackground(Color.clear)
                                
                            }
                            Spacer()
                        }.tabViewStyle(PageTabViewStyle()).listRowBackground(Color.clear)

                    }
                .listStyle(PlainListStyle())
                .toolbar{
                    ToolbarItem(placement: .principal){
                        HStack{
                            Spacer()
                            
                                Image(.globe)
                                    .resizable()
                                    .frame(width: 90, height: 60)
                                    .clipShape(Circle())
                                    .rotationEffect(.degrees(isRotating))
                                    .colorMultiply(.blue)
                            }.shadow(color: .red ,radius: 70, x: 60, y:60)
                            .onAppear{
                                withAnimation(.linear(duration: 0.5)
                                    .speed(0.01).repeatForever(autoreverses: false)){
                                        isRotating = 360.0
                                    }
                            }
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
                    }
                VStack {
                    if let location = locationService.location {
                        let startPosition = MapCameraPosition.region(
                            MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                            )
                        )
                        Map(initialPosition: startPosition)
                            .mapStyle(.hybrid)
                            .onTapGesture { position in
                                print("Tapped at \(position)")
                            }
                    } else {
                        Text("")
                    }
                }.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .padding()
                .onAppear {
                    locationService.requestLocation()
                }
                .refreshable {
                    locationService.requestLocation()
                }
            }.background(
                LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .top, endPoint: .bottom))
            }
        }
    }

        
#Preview {
    WeatherView()
}
