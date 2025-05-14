//
//  CityResponse.swift
//  SwiftUI-Weather
//
//  Created by Роман Вертячих on 13.05.2025.
//

import Foundation

struct CityResponse: Decodable {
    let id: Int
    let name: String
    let country: String
}
