//
//  ContentView.swift
//  WeatherApp
//
//  Created by user268934 on 11/22/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var weatherViewModel = WeatherViewModel()  // Observes changes in the ViewModel
    
    @State private var city: String = ""
    @State private var state: String = ""
    
    @State private var selectedLocation: Location? = nil  // For detail view navigation
    @State private var errorMessage: String? = nil        // For user feedback
    @State private var isLoading: Bool = false            // Loading indicator state
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 20) {
                // City and State Input Fields
                TextField("Enter City", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Enter State", text: $state)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Fetch Weather Button
                Button("Get Weather") {
                    Task {
                        await fetchLocationAndNavigate()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(city.isEmpty || state.isEmpty) // Prevents empty requests
                
                // Loading Indicator
                if isLoading {
                    ProgressView("Fetching data...")
                        .padding()
                }
                
                // Display Error Message if Any
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Navigation Links for Favorite Locations and Snapshots
                List {
                    NavigationLink("Favorite Locations", destination: FavoriteLocationsView(viewModel: weatherViewModel))
                    NavigationLink("Saved Snapshots", destination: SavedSnapshotsView(weatherViewModel: weatherViewModel))
                }
                .navigationTitle("Weather App")
            }
        } detail: {
            // Detail View: Shows weather details for selected location
            if let location = selectedLocation {
                LocationDetailView(location: location, weatherViewModel: weatherViewModel)
            } else {
                Text("Enter a city and state to get weather")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
        }
    }
    
    // MARK: - Fetch Location and Weather Data
    func fetchLocationAndNavigate() async {
        // Reset previous state
        errorMessage = nil
        isLoading = true
        
        do {
            // Fetch location data
            if let location = try await weatherViewModel.fetchLocation(city: city, state: state) {
                selectedLocation = location  // Navigate to detail view
                
                // Fetch weather data
                await weatherViewModel.fetchWeather(forCity: city, inState: state)
            } else {
                errorMessage = "No location found for \(city), \(state)"
            }
        } catch {
            errorMessage = "Error fetching data: \(error.localizedDescription)"
        }
        
        isLoading = false  // Stop loading indicator
    }
}

#Preview {
    ContentView()
}
