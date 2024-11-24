//
//  Location.swift
//  WeatherApp
//
//  Created by user268934 on 11/22/24.
//

import Foundation

struct Location: Identifiable, Encodable, Decodable, Hashable {
    var id: String
    let lat: Double
    let lon: Double
    let name: String
    let display_name: String
    let address: Address?
    
    private enum CodingKeys: String, CodingKey {
        case id = "place_id" // Map 'place_id' in the JSON to 'id' in the model
        case lat
        case lon
        case name
        case display_name
        case address
    }
    
    init(id: String, name: String, lat: Double, lon: Double, display_name: String, address: Address) {
        self.id = id
        self.name = name
        self.lat = lat
        self.lon = lon
        self.display_name = display_name
        self.address = address
    }
}

struct Address: Identifiable, Encodable, Decodable, Hashable {
    let city: String?
    let state: String?
    
    var id: String { "\(city ?? "") \(state ?? "") "}
}

struct FavoriteLocation: Identifiable, Codable {
    var id: String { location.id }
    let location: Location
}
