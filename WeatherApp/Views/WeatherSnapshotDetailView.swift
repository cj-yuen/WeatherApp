//
//  WeatherSnapshotDetailView.swift
//  WeatherApp
//
//  Created by user268934 on 11/23/24.
//

import SwiftUI

struct WeatherSnapshotDetailView: View {
    let weatherInfo: WeatherInfo
    let location: Location // Pass the location to use in saving favorites and snapshots
    @ObservedObject var weatherViewModel: WeatherViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                Text("Weather Snapshot")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                Text("Date: \(formattedDate())")
                    .font(.headline)
                
                Divider()

                weatherDetailRow(title: "Temperature", value: "\(formattedTemperature()) °F")
                weatherDetailRow(title: "Precipitation", value: "\(formattedPrecipitation()) mm")
                weatherDetailRow(title: "Precipitation Probability", value: "\(formattedPrecipitationProbability()) %")
                
                Spacer()
                
                Button(action: {
                    weatherViewModel.saveWeatherSnapshot(location: location, weatherInfo: weatherInfo)
                }) {
                    Text("Save Snapshot")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)

                Button(action: {
                    weatherViewModel.addFavoriteLocation(location: location)
                }) {
                    Text("Add to Favorites")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Snapshot Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Helper Functions
    private func formattedTemperature() -> String {
        guard let temp = weatherInfo.hourly.temperature_2m.first else {
            return "N/A"
        }
        return String(format: "%.1f", temp)
    }

    private func formattedPrecipitation() -> String {
        guard let precip = weatherInfo.hourly.precipitation.first else {
            return "N/A"
        }
        return String(format: "%.1f", precip)
    }

    private func formattedPrecipitationProbability() -> String {
        guard let probability = weatherInfo.hourly.precipitation_probability.first else {
            return "N/A"
        }
        return "\(probability)"
    }

    private func formattedDate() -> String {
        guard let isoDate = weatherInfo.hourly.time.first,
              let date = ISO8601DateFormatter().date(from: isoDate) else {
            return "Unknown Date"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // Helper view to display weather details consistently
    private func weatherDetailRow(title: String, value: String) -> some View {
        HStack {
            Text(title + ":")
                .font(.body)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.blue)
        }
        .padding(.horizontal)
    }
}
