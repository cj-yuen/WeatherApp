//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by user268934 on 11/23/24.
//

import Foundation

enum NetworkError: String, Error {
    case networkError = "Network error occurred"
    case invalidURL = "Invalid URL"
    case invalidResponse = "Invalid response from server"
    case decodingError = "Error decoding response data"
}

class NetworkManager {
    static let instance = NetworkManager()
    
    let locationAPIBaseURL = "https://nominatim.openstreetmap.org/search"
    let weatherAPIBaseURL = "https://api.open-meteo.com/v1/forecast"
    
    // Fetch Location Data from Nominatim API
    func getLocation(city: String, state: String) async throws -> [Location] {
        // URL encode the city and state to ensure it's safe for a URL
        let query = "\(city), \(state)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Construct the URL
        guard let url = URL(string: "\(locationAPIBaseURL)?q=\(query)&addressdetails=1&format=json") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Make the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200, httpResponse.statusCode <= 299 else {
            throw NetworkError.networkError
        }
        
        // Decode the response data
        do {
            let locationResponse = try JSONDecoder().decode([Location].self, from: data)
            return locationResponse
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // Fetch Weather Data from Open Meteo API
    func getWeather(latitude: Double, longitude: Double) async throws -> WeatherInfo {
        // Construct the weather URL
        guard let url = URL(string: "\(weatherAPIBaseURL)?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,precipitation_probability,precipitation&temperature_unit=fahrenheit&forecast_days=1") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Make the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200, httpResponse.statusCode <= 299 else {
            throw NetworkError.networkError
        }
        
        // Decode the weather data
        do {
            let weatherData = try JSONDecoder().decode(WeatherInfo.self, from: data)
            return weatherData
        } catch {
            throw NetworkError.decodingError
        }
    }
}
