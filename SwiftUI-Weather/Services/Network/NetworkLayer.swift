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
        static var myPostsPageSize = "30"
        static var locationPageSize = "10"
    }

    //MARK: - Constructions
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    //MARK: - Function
    
    func fetchWeather(city: String, completion: @escaping (Result<WeathersResponse, NetworkError>) -> Void) {
        networkManager.request(endpoint: "/data/2.5/forecast", parameters: ["q": city, "units": "metric", "appid": "92cabe9523da26194b02974bfcd50b7e"], completion: completion)
    }
}
