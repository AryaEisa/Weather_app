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
                
                List(feedModel.wData, id: \.timezone)
                { weatherData in
                    
                    VStack(alignment: .leading, spacing: 10)
                    {
                        
                        HStack
                        {
                            Text("Time: ").bold().foregroundColor(.black)
                            Text(weatherData.formattedTime)
                        }
                        
                        HStack
                        {
                            Text("City: ").font(.headline).bold().foregroundColor(.black)
                            Text(locationManager.cityname).foregroundColor(.black)
                        }
                        
                        HStack
                        {
                            Text("Temperature: ").bold().foregroundColor(.black)
                            Text("\(String(format: "%.1f", weatherData.current.temperature_2m)) °C").foregroundColor(.black)
                            Text(emojiForWeatherCode(weatherData.current.weather_code)).bold().font(.title).background(Color.gray).clipShape(Circle())
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                    
                        
                        ZStack{
                            HStack
                            {
                                Text("Time Zone")
                                    .bold()
                                    .foregroundColor(.black)
                                    .listRowBackground(Color.clear)
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                Spacer()
                            }
                            HStack
                            {
                                Text(":")
                            }
                            HStack
                            {
                                Spacer()
                                Text(weatherData.timezone)
                                    .foregroundColor(.black)
                                    .padding()
                                    .listRowBackground(Color.clear)
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                
                            }
                            
                        }
                       
                        
                        
                    
                    
                    .listRowBackground(Color.clear)
                    
                    
                    ZStack{
                        HStack{
                            Text("")
                            Spacer()
                        }
                        
                        HStack{
                            Text("7-days forecast")
                                .toolbarTitleDisplayMode(.inline)
                                .listRowBackground(Color.clear)
                                .bold()
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                
                        }
                        HStack{
                            Spacer()
                            Text("")
                        }
                        
                        
                    } .listRowBackground(Color.clear)
                        TabView {
                            ForEach(0..<7) { index in
                                
                                HStack {
                                    
                                    Text(weatherData.daily.formattedDayOfWeek(forIndex: index))
                                    
                                    Spacer()
                                    Text(emojiForWeatherCode(weatherData.daily.weather_code[index])).background(Color.gray).clipShape(Circle())
                                    Spacer()
                                    Text("\(weatherData.daily.temperature_2m_max[index], specifier: "%.1f")°C").font(.title).bold()
                                    
                                    
                                    
                                }
                                .listRowBackground(Color.clear)
                                
                            }
                            
                            //Spacer()
                            
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .listRowBackground(Color.clear)
                        .frame(minHeight: 80)

                    }
                .listStyle(PlainListStyle())
                .toolbar{
                    ToolbarItem(placement: .principal)
                    {
                        HStack
                        {
                            Spacer()
                            
                                Image(.globe)
                                    .resizable()
                                    .frame(width: 90, height: 60)
                                    .clipShape(Circle())
                                    .rotationEffect(.degrees(isRotating))
                                    .colorMultiply(.blue)
                            }
                        .shadow(color: .red ,radius: 70, x: 60, y:60)
                        .onAppear
                        {
                        withAnimation(.linear(duration: 0.5)
                        .speed(0.01).repeatForever(autoreverses: false))
                            {
                                isRotating = 360.0
                            }
                        }
                    }
                }
                
                .onAppear {
                    Task {
                        locationManager.requestLocation()
                        if let firstWeatherData = feedModel.wData.first
                        {
                            let userDefaults = UserDefaults(suiteName: "group.by.temp")
                            
                            let temp: Double = firstWeatherData.current.temperature_2m
                            
                            userDefaults?.set(temp, forKey: "currentTemp")
                            
                            WidgetCenter.shared.reloadAllTimelines()
                            
                        }
                    }
                }
                VStack
                {
                    
                    if let location = locationService.location
                    {
                        let startPosition = MapCameraPosition.region( MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                            )
                        )
                        Map(initialPosition: startPosition)
                            .mapStyle(.hybrid).frame(width: 300, height: 300)
                            .onTapGesture { position in
                                print("Tapped at \(position)")
                            }
                    } else
                        {
                        Text("")
                        }
                }
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .padding()
                .onAppear
                {
                    locationService.requestLocation()
                }
                .refreshable
                {
                    locationService.requestLocation()
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.white, .mint]), startPoint: .top, endPoint: .bottom))
            }
        }
    }

        

#Preview {
    WeatherView()
}

 
