//
//  LocationListView.swift
//  WeatherApp
//
//  Created by user268934 on 11/22/24.
//

import SwiftUI

struct LocationDetailView: View {
    let location: Location
    @ObservedObject var weatherViewModel: WeatherViewModel // Ensure it's passed as an observed object
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Display the location's city name (from the geocoding API)
                Text("Location: \(location.address.city ?? "Unknown City")")
                    .font(.title)
                    .bold()
                    .padding(.top)

                Divider()

                // Weather Information Section
                if let weatherInfo = weatherViewModel.weatherInfo {
                    Group {
                        Text("Temperature: \(formattedTemperature(weatherInfo)) °F")
                            .font(.headline)
                        Text("Precipitation: \(formattedPrecipitation(weatherInfo)) mm")
                            .font(.headline)
                        Text("Precipitation Probability: \(formattedPrecipitationProbability(weatherInfo)) %")
                            .font(.headline)
                    }
                    .padding(.vertical)
                } else if weatherViewModel.isLoading {
                    ProgressView("Loading Weather Data...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let errorMessage = weatherViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.body)
                }

                // Action Buttons
                HStack {
                    Button(action: {
                        if let weatherInfo = weatherViewModel.weatherInfo {
                            weatherViewModel.saveWeatherSnapshot(location: location, weatherInfo: weatherInfo)
                        }
                    }) {
                        Text("Save Snapshot")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        weatherViewModel.addFavoriteLocation(location: location)
                    }) {
                        Text("Add to Favorites")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.top)
            }
            .padding()
            .navigationTitle("Location Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                await weatherViewModel.fetchWeather(forCity: location.address.city ?? "", inState: location.address.state ?? "")
            }
        }
    }
    
    // MARK: - Helper Functions
    private func formattedTemperature(_ weatherInfo: WeatherInfo) -> String {
        guard let temp = weatherInfo.hourly.temperature_2m.first else {
            return "N/A"
        }
        return String(format: "%.1f", temp)
    }

    private func formattedPrecipitation(_ weatherInfo: WeatherInfo) -> String {
        guard let precip = weatherInfo.hourly.precipitation.first else {
            return "N/A"
        }
        return String(format: "%.1f", precip)
    }

    private func formattedPrecipitationProbability(_ weatherInfo: WeatherInfo) -> String {
        guard let probability = weatherInfo.hourly.precipitation_probability.first else {
            return "N/A"
        }
        return "\(probability)"
    }
}

#Preview {
    LocationDetailView(
        location: Location(id: "2", name: "San Francisco", lat: 37.7749, lon: -122.4194, display_name: "San Francisco, CA", address: Address(city: "San Francisco", state: "CA")),
        weatherViewModel: WeatherViewModel()  // Mock WeatherViewModel instance
    )
}

