//
//  WeathersResponse.swift
//  SwiftUI-Weather
//
//  Created by Роман Вертячих on 14.05.2025.
//

import Foundation

struct WeathersResponse: Decodable {
    let list: [ListResponse]
    let city: CityResponse
}

struct ListResponse: Decodable {
    let date: Double
    let temperature: TemperatureResponse
    let weather: [WeatherResponse]
    let dateStr: String
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "main"
        case weather
        case dateStr = "dt_txt"
    }
}

struct TemperatureResponse: Decodable {
    let value: Double
    let valueMax: Double
    let valueMin: Double
    
    enum CodingKeys: String, CodingKey {
        case value = "temp"
        case valueMax = "temp_min"
        case valueMin = "temp_max"
    }
}

struct WeatherResponse: Decodable {
    let id: Int
    let value: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case value = "main"
        case description
        case icon
    }
}
