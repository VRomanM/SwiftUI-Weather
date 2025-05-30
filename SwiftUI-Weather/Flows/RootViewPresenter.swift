//
//  RootViewPresenter.swift
//  SwiftUI-Weather
//
//  Created by Роман Вертячих on 14.05.2025.
//

import Foundation

struct WeatherDaysOfWeek {
    var city: String
    let daysOfWeek: [WeatherDay]
    let daysOfWeekNight: [WeatherDay]
}

struct WeatherDay {
    let day: String
    let temperature: Int
    let imageName: String
}

enum ImageWeather: String {
    case sun = "Sun"
    case clouds = "Clouds"
    case rain = "Rain"
    case clear = "Clear"
    
    var image: String {
        switch self {
        case .sun:
            return "sun.max.fill"
        case .clouds:
            return "cloud.fill"
        case .rain:
            return "cloud.rain.fill"
        case .clear:
            return "sun.horizon.fill"
        }
    }
}


final class RootViewPresenter {
    
    //MARK: - Properties
    
    var weatherDaysOfWeek: WeatherDaysOfWeek
    let cities = ["Moscow", "Saint Petersburg", "Kazan", "Omsk"]
    
    //MARK: - Private properties
    
    private let networkLayer = NetworkLayer(networkManager: NetworkManager())
    
    //MARK: - Constructions
    
    init() {
        self.weatherDaysOfWeek = networkLayer.defaultWeatherForTest()
    }
    
    //MARK: - Private function
    
    private func buildWeatherDaysOfWeek(weathersResponse: WeathersResponse) -> WeatherDaysOfWeek {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE" // "Пнд"
        var daysOfWeek = [WeatherDay]()
        var daysOfWeekNight = [WeatherDay]()
        
        var previousDay = ""
        
        for n in 0..<weathersResponse.list.count {
            let dateStr = dateFormatter.string(from: Date(timeIntervalSince1970: weathersResponse.list[n].date))
            let weatherIcon = ImageWeather(rawValue: weathersResponse.list[n].weather[0].value)?.image ?? "photo"
            if n == 0 {
                daysOfWeek.append(WeatherDay(day: dateStr, temperature: Int(weathersResponse.list[n].temperature.value), imageName: weatherIcon))
                previousDay = dateStr
                continue
            }
            if n == weathersResponse.list.count - 1 {
                daysOfWeekNight.append(WeatherDay(day: previousDay, temperature: Int(weathersResponse.list[n].temperature.value), imageName: weatherIcon))
                continue
            }
            if dateStr != previousDay {
                let weatherPreviousIcon = ImageWeather(rawValue: weathersResponse.list[n - 1].weather[0].value)?.image ?? "photo"
                daysOfWeek.append(WeatherDay(day: dateStr, temperature: Int(weathersResponse.list[n].temperature.value), imageName: weatherIcon))
                daysOfWeekNight.append(WeatherDay(day: previousDay, temperature: Int(weathersResponse.list[n - 1].temperature.value), imageName: weatherPreviousIcon))
                previousDay = dateStr
            }
        }
        
        let weatherDaysOfWeek = WeatherDaysOfWeek(city: weathersResponse.city.name, daysOfWeek: daysOfWeek, daysOfWeekNight: daysOfWeekNight)
        return weatherDaysOfWeek
    }
    
    //MARK: - Function
    
    func fetchWeather(city: String, completion: @escaping (Bool) -> Void) {
        networkLayer.fetchWeather(city: city) { result in
            switch result {
            case .success(let model):
                self.weatherDaysOfWeek = self.buildWeatherDaysOfWeek(weathersResponse: model)
            case .failure(let error):
                print(error.description)
                self.weatherDaysOfWeek = self.networkLayer.defaultWeatherForTest()
            }
            completion(false)
        }
    }
}
