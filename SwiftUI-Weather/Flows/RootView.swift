//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Роман Вертячих on 11.05.2025.
//

import SwiftUI

struct RootView: View {
    
    @State private var isNight = false
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: $isNight)
            VStack {
                CityTextView(cityName: "Cupertino, CA")
                MainWeatherStatusView(imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill",
                                      temperature: 76)
                HStack(spacing: 10) {
                    WeatherDayView(dayOfWeek: "TUE", imageName: "cloud.sun.fill", temperature: 10)
                    WeatherDayView(dayOfWeek: "WED", imageName: "sun.max.fill", temperature: 15)
                    WeatherDayView(dayOfWeek: "THU", imageName: "wind.snow", temperature: 5)
                    WeatherDayView(dayOfWeek: "FRI", imageName: "sunset.fill", temperature: 3)
                    WeatherDayView(dayOfWeek: "SAT", imageName: "snow", temperature: 0)
                }
                Spacer()
                
                Button {
                    let networkLayer = NetworkLayer(networkManager: NetworkManager())
                    networkLayer.fetchWeather(city: "Moscow") { result in
                        switch result {
                        case .success(let model):
                            let date = Date(timeIntervalSince1970: model.list[0].date)
                            //let date = model.list[0].date
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "YYYY/MM/dd"
                            
                            print("\(dateFormatter.string(from: date))")
                        case .failure(let error):
                            print(error.description)
                        }
                    }
                    isNight.toggle()
                    
                } label: {
                    WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    RootView()
}

struct WeatherDayView: View {
    
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding()
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temperature)°")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .padding()
        }
    }
}

struct BackgroundView: View {
    
    @Binding var isNight: Bool
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue, isNight ? .gray : .lightBlue]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View {
    var cityName: String
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            Text("\(temperature)°C")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
            
        }
        .padding(.bottom, 40)
    }
}
