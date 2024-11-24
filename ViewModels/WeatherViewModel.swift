//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by user268934 on 11/22/24.
//

import Foundation
import Combine
import CoreData

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherInfo: WeatherInfo? = nil
    @Published var location: Location?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var savedWeatherSnapshots: [WeatherSnapshot] = []  // Use Core Data entities
    @Published var favoriteLocations: [Location] = []
    
    // Core Data stack setup
    let persistentContainer: NSPersistentContainer
    private let networkManager = NetworkManager.instance
    
    init() {
        persistentContainer = NSPersistentContainer(name: "WeatherAppModel")  // Replace with your model name
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        loadSnapshotsFromCoreData()  // Load Core Data snapshots on initialization
        loadFavoriteLocations()
    }
    
    // MARK: - Core Data Functions
    
    func saveWeatherSnapshot(location: Location, weatherInfo: WeatherInfo) {
        let context = persistentContainer.viewContext
        
        let snapshotEntity = WeatherSnapshotEntity(context: context)
        snapshotEntity.timestamp = Date()
        snapshotEntity.locationName = location.name
        snapshotEntity.latitude = location.lat
        snapshotEntity.longitude = location.lon
        snapshotEntity.temperature = weatherInfo.hourly.temperature_2m.first ?? 0.0
        snapshotEntity.precipitation = weatherInfo.hourly.precipitation.first ?? 0.0
        
        do {
            try context.save()
            loadSnapshotsFromCoreData()  // Refresh after saving
        } catch {
            print("Failed to save snapshot: \(error.localizedDescription)")
        }
    }
    
    func loadSnapshotsFromCoreData() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherSnapshotEntity> = WeatherSnapshotEntity.fetchRequest()

        do {
            let snapshotEntities = try context.fetch(fetchRequest)
            savedWeatherSnapshots = snapshotEntities.map { entity in
                let timeArray = entity.time?.split(separator: ",").map { String($0) } ?? []
                
                return WeatherSnapshot(
                    timestamp: entity.timestamp ?? Date(),
                    location: Location(
                        id: entity.locationName ?? "",
                        name: entity.locationName ?? "",
                        lat: entity.latitude,
                        lon: entity.longitude,
                        display_name: entity.locationName ?? "",
                        address: Address(city: "Philadelphia", state: "Pennsylvania")
                    ),
                    weatherInfo: WeatherInfo(
                        hourly: WeatherInfo.Hourly(
                            time: timeArray,
                            temperature_2m: [entity.temperature],
                            precipitation_probability: [Double(entity.precipitationProbability)],
                            precipitation: [entity.precipitation]
                        )
                    )
                )
            }
        } catch {
            print("Failed to fetch snapshots: \(error.localizedDescription)")
        }
    }
    
    func deleteSnapshot(snapshot: WeatherSnapshotEntity) {
        let context = persistentContainer.viewContext
        context.delete(snapshot)
        
        do {
            try context.save()
            loadSnapshotsFromCoreData()
        } catch {
            print("Failed to delete snapshot: \(error.localizedDescription)")
        }
    }
    
    func addFavoriteLocation(location: Location) {
        favoriteLocations.append(location)
        saveFavoriteLocations()
    }
    
    func removeFavoriteLocation(location: Location) {
            if let index = favoriteLocations.firstIndex(where: { $0.id == location.id }) {
                favoriteLocations.remove(at: index)
            }
        }

    private func saveFavoriteLocations() {
        if let encoded = try? JSONEncoder().encode(favoriteLocations) {
            UserDefaults.standard.set(encoded, forKey: "favoriteLocations")
        }
    }

    private func loadFavoriteLocations() {
        if let savedData = UserDefaults.standard.data(forKey: "favoriteLocations"),
           let decodedLocations = try? JSONDecoder().decode([Location].self, from: savedData) {
            favoriteLocations = decodedLocations
        }
    }
    
    // MARK: - Fetch Weather and Location Functions
    // Modify fetchLocation to return a Location? instead of void
    func fetchLocation(city: String, state: String) async throws -> Location? {
        do {
            // Fetch locations
            let locations = try await networkManager.getLocation(city: city, state: state)
            
            // Return the first location or nil if no locations are found
            return locations.first
        } catch {
            // Handle error
            throw error
        }
    }


    
    func fetchWeather(forCity city: String, inState state: String) async {
        isLoading = true
        
        Task {
            do {
                let location = try await NetworkManager.instance.getLocation(city: city, state: state)
                
                let firstLocation = location.first
                
                let weather = try await NetworkManager.instance.getWeather(latitude: firstLocation?.lat ?? 0, longitude: firstLocation?.lon ?? 0)
                
                // Update the state on the main thread
                await MainActor.run {
                    self.location = firstLocation
                    self.weatherInfo = weather
                    self.isLoading = false
                }
                
                print("Weather data fetched successfully for \(city), \(state).")
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
                
                print("Failed to fetch weather data for \(city), \(state): \(error)")
            }
        }
    }

}
