//
//  LocationViewModel.swift
//  WeatherApp
//
//  Created by user268934 on 11/23/24.
//

import Foundation

class LocationViewModel: ObservableObject {
    @Published var favoriteLocations: [Location] = []  // List of favorite locations
    
    // Keys for saving data in UserDefaults
    private let favoriteLocationsKey = "favoriteLocationsKey"

    // MARK: - Initializer
    init() {
        loadData()  // Load favorite locations from persistent storage
    }

    // MARK: - Load and Save Data
    private func loadData() {
        // Load saved favorite locations from UserDefaults if available
        if let data = UserDefaults.standard.data(forKey: favoriteLocationsKey),
           let decodedLocations = try? JSONDecoder().decode([Location].self, from: data) {
            favoriteLocations = decodedLocations
        }
    }

    private func saveData() {
        // Save favorite locations to UserDefaults
        if let encodedLocations = try? JSONEncoder().encode(favoriteLocations) {
            UserDefaults.standard.set(encodedLocations, forKey: favoriteLocationsKey)
        }
    }

    // MARK: - Add/Remove Locations
    func addFavoriteLocation(location: Location) {
        favoriteLocations.append(location)
        saveData()  // Save updated favorite locations
    }

    func removeFavoriteLocation(at index: Int) {
        favoriteLocations.remove(at: index)
        saveData()  // Save updated favorite locations
    }
}
