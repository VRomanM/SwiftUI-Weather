//
//  NetworkError.swift
//  SwiftUI-Weather
//
//  Created by Роман Вертячих on 13.05.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL(APIError?)
    case dataNotFound(description: String?)
    case decodingError(APIError?)
    case encodingError(APIError?)
    case badRequest(APIError?)
    case unauthorized(APIError?)
    case forbidden(APIError?)
    case notFound(APIError?)
    case internalServerError(APIError?)
    case unknownError(statusCode: Int, message: String?)
    
    var description: String {
        switch self {
        case .invalidURL(let error):
            return error?.message ?? ""
        case .dataNotFound(let text):
            return text ?? "Data not found"
        case .decodingError(let error):
            return error?.message ?? ""
        case .encodingError(let error):
            return error?.message ?? ""
        case .badRequest(let error):
            return error?.message ?? ""
        case .unauthorized(let error):
            return error?.message ?? ""
        case .forbidden(let error):
            return error?.message ?? ""
        case .notFound(let error):
            return error?.message ?? ""
        case .internalServerError(let error):
            return error?.message ?? ""
        case .unknownError(_, let error):
            return error ?? ""
        }
    }
    
    var suggested_usernames: [String]? {
        switch self {
        case .badRequest(let error):
            return error?.suggested_usernames
        default: return nil
        }
    }
}

struct APIError: Decodable {
    let message: String
    let suggested_usernames: [String]?
}
