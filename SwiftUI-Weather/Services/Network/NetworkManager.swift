//
//  NetworkManager.swift
//  SwiftUI-Weather
//
//  Created by Роман Вертячих on 13.05.2025.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol RequestInterceptor {
    func intercept(_ request: URLRequest) -> URLRequest
}

final class NetworkManager {
    
    //MARK: - Private properties
    
    private let session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 30
        return URLSession(configuration: sessionConfiguration)
    }()
    private let baseURL = URL(string: "https://api.openweathermap.org")
    private var interceptors: [RequestInterceptor] = []
    private var refreshTokenCounter = 0
    
    //MARK: - Properties
    
    enum Headers {
        case json
        case multipartFormData(String)
        
        var values: [String: String] {
            switch self {
            case .json:
                let headers = ["Content-Type":"application/json", "Accept": "application/json"]
                return headers
            case .multipartFormData(let boundary):
                let headers = ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
                return headers
            }
        }
    }
    
    //MARK: - Private function
    
    private func prepareRequest(
        url: URL,
        method: HttpMethod,
        headers: [String: String]?,
        body: Data?
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        applyHeaders(headers, to: &request)
        applyInterceptors(to: &request)
        return request
    }
    
    private func applyHeaders(_ headers: [String: String]?, to request: inout URLRequest) {
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    private func applyInterceptors(to request: inout URLRequest) {
        for interceptor in interceptors {
            request = interceptor.intercept(request)
        }
    }
    
    private func processRequest<T: Decodable>(
        request: URLRequest,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    completion(.failure(.dataNotFound(description: error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.dataNotFound(description: nil)))
                    return
                }
                
                self.handleResponse(httpResponse: httpResponse, request: request, data: data, completion: completion)
            }
        }.resume()
    }
    
    private func handleResponse<T: Decodable>(
        httpResponse: HTTPURLResponse,
        request: URLRequest,
        data: Data?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        switch httpResponse.statusCode {
        case 200...299: // Success
            guard let data = data else {
                completion(.failure(.dataNotFound(description: nil)))
                return
            }
            
            decodeData(data, completion: completion)

        case 400:
            let errorMessage = decodeErrorMessage(from: data)
            completion(.failure(.badRequest(errorMessage)))
        case 401:
            let errorMessage = decodeErrorMessage(from: data)
            completion(.failure(.badRequest(errorMessage)))
        case 403:
            let errorMessage = decodeErrorMessage(from: data)
            completion(.failure(.forbidden(errorMessage)))
        case 404:
            let errorMessage = decodeErrorMessage(from: data)
            completion(.failure(.notFound(errorMessage)))
        case 500:
            let errorMessage = decodeErrorMessage(from: data)
            completion(.failure(.internalServerError(errorMessage)))
        default:
            let errorMessage = decodeErrorMessage(from: data)
            completion(.failure(.unknownError(statusCode: httpResponse.statusCode, message: errorMessage?.message)))
        }
    }
    
    private func decodeData<T: Decodable>(_ data: Data, completion: @escaping (Result<T, NetworkError>) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            print(error)
            completion(.failure(.decodingError(APIError(message: error.localizedDescription, suggested_usernames: nil))))
        }
    }
    
    private func decodeErrorMessage(from data: Data?) -> APIError? {
        guard let data = data else { return nil }
        let decodedError = try? JSONDecoder().decode(APIError.self, from: data)
        return decodedError
    }
    
    //MARK: - Function
    
    func addInterceptor(_ interceptor: RequestInterceptor) {
        interceptors.append(interceptor)
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: HttpMethod = .get,
        headers: [String: String] = Headers.json.values,
        parameters: [String: String]? = nil,
        body: Data? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var url = baseURL?.appendingPathComponent(endpoint)
        
        if let parameters = parameters {
            var components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            url = components?.url
        }
        
        guard let finalURL = url else {
            completion(.failure(.invalidURL(.init(message: "url is not correct", suggested_usernames: nil))))
            return
        }
        
        let request = prepareRequest(url: finalURL, method: method, headers: headers, body: body)
        processRequest(request: request, completion: completion)
    }
}
