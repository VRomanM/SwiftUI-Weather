//
//  NetworkLayer.swift
//  SwiftUI-Weather
//
//  Created by Роман Вертячих on 13.05.2025.
//

import Foundation

final class NetworkLayer {
    
    //MARK: - Private properties
    
    private let networkManager: NetworkManager
    
    //MARK: - Properties
    
    enum Constants {
        static var pageSize = "30"
    }

    //MARK: - Constructions
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    //MARK: - Function
    
    func fetchWeather(city: String, completion: @escaping (Result<WeathersResponse, NetworkError>) -> Void) {
        networkManager.request(endpoint: "/data/2.5/forecast", parameters: ["q": city, "units": "metric", "appid": "92cabe9523da26194b02974bfcd50b7e"], completion: completion)
    }
    
    func defaultWeatherForTest() -> WeatherDaysOfWeek {
        var daysOfWeek: [WeatherDay] = []
        daysOfWeek.append(WeatherDay(day: "MON", temperature: 10, imageName: "cloud.sun.fill"))
        daysOfWeek.append(WeatherDay(day: "TUE", temperature: 12, imageName: "sun.max.fill"))
        daysOfWeek.append(WeatherDay(day: "WED", temperature: 13, imageName: "wind.snow"))
        daysOfWeek.append(WeatherDay(day: "THU", temperature: 14, imageName: "cloud.sun.fill"))
        daysOfWeek.append(WeatherDay(day: "FRI", temperature: 15, imageName: "cloud.sun.fill"))
        daysOfWeek.append(WeatherDay(day: "SAT", temperature: 16, imageName: "sunset.fill"))
        daysOfWeek.append(WeatherDay(day: "SUN", temperature: 17, imageName: "cloud.sun.fill"))
        
        var daysOfWeekNight: [WeatherDay] = []
        daysOfWeekNight.append(WeatherDay(day: "MON", temperature: -10, imageName: "moon.stars.fill"))
        daysOfWeekNight.append(WeatherDay(day: "TUE", temperature: -15, imageName: "sun.max.fill"))
        daysOfWeekNight.append(WeatherDay(day: "WED", temperature: -20, imageName: "wind.snow"))
        daysOfWeekNight.append(WeatherDay(day: "THU", temperature: -25, imageName: "cloud.sun.fill"))
        daysOfWeekNight.append(WeatherDay(day: "FRI", temperature: -30, imageName: "cloud.sun.fill"))
        daysOfWeekNight.append(WeatherDay(day: "SAT", temperature: -35, imageName: "sunset.fill"))
        daysOfWeekNight.append(WeatherDay(day: "SUN", temperature: -40, imageName: "cloud.sun.fill"))
        
        let weatherDaysOfWeek = WeatherDaysOfWeek(city: "Moscow", daysOfWeek: daysOfWeek, daysOfWeekNight: daysOfWeekNight)
        return weatherDaysOfWeek
    }
}
