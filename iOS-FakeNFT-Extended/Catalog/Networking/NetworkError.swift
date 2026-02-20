//
//  NetworkError.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 19.02.2026.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case serverError(Int)
    case decodingError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Неверный URL-адрес."
        case .noData: return "Нет данных от сервера."
        case .serverError(let statusCode): return "Ошибка сервера: код \(statusCode)."
        case .decodingError(let error): return "Ошибка декодирования данных: \(error.localizedDescription)"
        case .unknown(let error): return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
}
