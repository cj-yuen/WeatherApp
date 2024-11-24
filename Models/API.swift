//
//  API.swift
//  WeatherApp
//
//  Created by user268934 on 11/23/24.
//

import Foundation

struct GeocodingAPIResponse: Decodable {
    let lat: Double
    let lon: Double
    let name: String
    let display_name: String
    let address: AddressAPIResponse
    let id: String
}

struct AddressAPIResponse: Decodable {
    let city: String?
    let state: String?
}
