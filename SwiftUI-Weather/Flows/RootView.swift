//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Роман Вертячих on 11.05.2025.
//

import SwiftUI

struct RootView: View {
    
    @State private var isNight = false
    @State var weatherDaysOfWeek: WeatherDaysOfWeek?
    @State var rootViewPresenter: RootViewPresenter?
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: $isNight)
            VStack {
                if let weatherDaysOfWeek = weatherDaysOfWeek {
                    CityTextView(cityName: weatherDaysOfWeek.city)
                    MainWeatherStatusView(imageName: isNight ? weatherDaysOfWeek.daysOfWeekNight[0].imageName : weatherDaysOfWeek.daysOfWeek[0].imageName,
                                          temperature: isNight ? weatherDaysOfWeek.daysOfWeekNight[0].temperature : weatherDaysOfWeek.daysOfWeek[0].temperature)
                    HStack(spacing: 10) {
                        ForEach(weatherDaysOfWeek.daysOfWeek.indices, id: \.self) { index in
                            if index != 0 && index != 6 {
                                WeatherDayView(dayOfWeek: weatherDaysOfWeek.daysOfWeek[index].day,
                                               imageName: weatherDaysOfWeek.daysOfWeek[index].imageName,
                                               temperature: weatherDaysOfWeek.daysOfWeek[index].temperature)
                            }
                        }
                    }
                }
                Spacer()
                
                Button {
                    isNight.toggle()
                    
                } label: {
                    WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
                }
                Spacer()
            }
        }.onAppear() {
            rootViewPresenter = RootViewPresenter()
            weatherDaysOfWeek = rootViewPresenter?.fetchWeather(city: "Moscow")
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
