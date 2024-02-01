//
//  ContentView.swift
//  weatherApp.swift
//
//  Created by Arya Pour Eisa on 2024-01-22.
//

import SwiftUI


struct ContentView: View {
  
    
    var date: Date? {
        let string = "20:32 Wed, 30 Oct 2019"
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "HH:mm E, d MMM y"
        return formatter4.date(from: string)
    }
    
    var formattedDate: String {
        let today = Date.now
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .medium
        return formatter1.string(from: today)
    }

    var body: some View {
        
        //Text("\(date?.debugDescription ?? "Error")")
        //Text(formattedDate)
        WeatherView()
          
    }
}

#Preview {
    ContentView()
}
