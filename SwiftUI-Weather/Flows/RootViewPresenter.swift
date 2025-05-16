//
//  RootViewPresenter.swift
//  SwiftUI-Weather
//
//  Created by Роман Вертячих on 14.05.2025.
//

import Foundation

struct WeatherDaysOfWeek {
    let city: String
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
    
    var image: String {
        switch self {
        case .sun:
            return "sun.max.fill"
        case .clouds:
            return "cloud.fill"
        case .rain:
            return "cloud.rain.fill"
        }
    }
}

final class RootViewPresenter {
    
    private var weatherDaysOfWeek = WeatherDaysOfWeek(city: "Moscow", daysOfWeek: [WeatherDay](), daysOfWeekNight: [WeatherDay]())
    
    //MARK: - Private properties
    
    private let networkLayer = NetworkLayer(networkManager: NetworkManager())
    
    //MARK: - Private function
    
    private func defaultWeatherForTest() -> WeatherDaysOfWeek {
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
    
    func fetchWeather(city: String) -> WeatherDaysOfWeek {
        networkLayer.fetchWeather(city: city) { result in
            switch result {
            case .success(let model):
                self.weatherDaysOfWeek = self.buildWeatherDaysOfWeek(weathersResponse: model)
            case .failure(let error):
                print(error.description)
                self.weatherDaysOfWeek = self.defaultWeatherForTest()
            }
        }
        return weatherDaysOfWeek
    }
}
