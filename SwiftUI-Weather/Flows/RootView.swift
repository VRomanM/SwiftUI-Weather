//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Роман Вертячих on 11.05.2025.
//

import SwiftUI

struct RootView: View {
    
    //MARK: - Private properties
    
    @State private var isNight = false
    @State private var rootViewPresenter: RootViewPresenter
    @State private var isLoading = false
    
    //MARK: - View
    
    var body: some View {
        TabView {
            ForEach(0..<4, id: \.self) { index in
                ZStack {
                    BackgroundView(isNight: $isNight)
                    WeatherView(city: rootViewPresenter.cities[index], isNight: $isNight, isLoading: $isLoading, rootViewPresenter: rootViewPresenter)
                }
                .tabItem {
                    Text("\(rootViewPresenter.cities[index])")
                }
                .tag(index)
            }
        }
    }
    
    //MARK: - Constructions
    
    init(isNight: Bool = false) {
        self.isNight = isNight
        self.rootViewPresenter = RootViewPresenter()
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

struct WeatherView: View {
    var city: String
    @Binding var isNight: Bool
    @Binding var isLoading: Bool
    var rootViewPresenter: RootViewPresenter
    
    var body: some View {
        VStack {
            if isLoading == false {
                CityTextView(cityName: rootViewPresenter.weatherDaysOfWeek.city)
                MainWeatherStatusView(imageName: isNight ? rootViewPresenter.weatherDaysOfWeek.daysOfWeekNight[0].imageName : rootViewPresenter.weatherDaysOfWeek.daysOfWeek[0].imageName,
                                      temperature: isNight ? rootViewPresenter.weatherDaysOfWeek.daysOfWeekNight[0].temperature : rootViewPresenter.weatherDaysOfWeek.daysOfWeek[0].temperature)
                HStack(spacing: 10) {
                    ForEach(rootViewPresenter.weatherDaysOfWeek.daysOfWeek.indices, id: \.self) { index in
                        if index != 0 && index != 6 {
                            WeatherDayView(dayOfWeek: isNight ? rootViewPresenter.weatherDaysOfWeek.daysOfWeekNight[index].day : rootViewPresenter.weatherDaysOfWeek.daysOfWeek[index].day,
                                           imageName: isNight ? rootViewPresenter.weatherDaysOfWeek.daysOfWeekNight[index].imageName : rootViewPresenter.weatherDaysOfWeek.daysOfWeek[index].imageName,
                                           temperature: isNight ? rootViewPresenter.weatherDaysOfWeek.daysOfWeekNight[index].temperature : rootViewPresenter.weatherDaysOfWeek.daysOfWeek[index].temperature)
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
        }.onAppear() {
            isLoading = true
            rootViewPresenter.fetchWeather(city: city) { result in
                DispatchQueue.main.async {
                    self.isLoading = result
                }
            }
        }
    }
}
