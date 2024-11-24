//
//  SavedSnapshotsView.swift
//  WeatherApp
//
//  Created by user268934 on 11/23/24.
//

import SwiftUI

struct SavedSnapshotsView: View {
    @ObservedObject var weatherViewModel: WeatherViewModel

    var body: some View {
        NavigationView {
            List(weatherViewModel.savedWeatherSnapshots) { snapshot in
                NavigationLink(destination: WeatherSnapshotDetailView(weatherInfo: snapshot.weatherInfo, location: snapshot.location, weatherViewModel: weatherViewModel)) {
                    VStack(alignment: .leading) {
                        Text(snapshot.location.name)  // Location name
                        Text("Snapshot at: \(snapshot.timestamp, style: .date)") // Timestamp
                    }
                }
            }
            .navigationTitle("Saved Snapshots")
        }
    }
}

#Preview {
    // Sample weather data
    let sampleWeatherInfo = WeatherInfo(
        hourly: WeatherInfo.Hourly(
            time: ["2024-03-25T00:00"],
            temperature_2m: [41.3],
            precipitation_probability: [97],
            precipitation: [0.3]
        )
    )

    // Sample location data
    let sampleLocation = Location(
        id: "123",
        name: "Berlin",
        lat: 52.52,
        lon: 13.41,
        display_name: "Berlin, Germany",
        address: Address(city: "Berlin", state: "Berlin")
    )

    // Sample weather snapshot
    let sampleSnapshot = WeatherSnapshot(
        timestamp: Date(),
        location: sampleLocation,
        weatherInfo: sampleWeatherInfo
    )

    // Mock WeatherViewModel with the sample snapshot
    let mockViewModel = WeatherViewModel()

    // Use the SavedSnapshotsView with the mock data
    SavedSnapshotsView(weatherViewModel: mockViewModel)
}
