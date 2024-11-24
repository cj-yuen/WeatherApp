//
//  Weather.swift
//  WeatherApp
//
//  Created by user268934 on 11/22/24.
//

import Foundation

// Main weather info model to hold the data
struct WeatherInfo: Codable {
    var hourly: Hourly
    
    struct Hourly: Codable {
        var time: [String]  // The time is in String format for now (ISO8601)
        var temperature_2m: [Double]
        var precipitation_probability: [Double]
        var precipitation: [Double]
    }
}

struct WeatherSnapshot: Identifiable, Codable {
    var id: String { location.id }
    let timestamp: Date
    let location: Location
    let weatherInfo: WeatherInfo
}
