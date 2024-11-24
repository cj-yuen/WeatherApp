//
//  FavoriteLocationsView.swift
//  WeatherApp
//
//  Created by user268934 on 11/23/24.
//

import SwiftUI

struct FavoriteLocationsView: View {
    @ObservedObject var viewModel: WeatherViewModel  // ViewModel for favorite locations
    
    var body: some View {
        List {
            ForEach(viewModel.favoriteLocations, id: \.id) { location in
                NavigationLink(destination: LocationDetailView(location: location, weatherViewModel: viewModel)) {
                    Text(location.name)
                        .font(.headline)
                }
            }
            .onDelete { indexSet in
                deleteFavoriteLocations(at: indexSet)
            }
        }
        .navigationTitle("Favorite Locations")
        .toolbar {
            EditButton()  // Allows users to delete locations easily
        }
    }
    
    // MARK: - Delete Locations Safely
    private func deleteFavoriteLocations(at offsets: IndexSet) {
        for index in offsets {
            DispatchQueue.main.async {
                viewModel.removeFavoriteLocation(location: viewModel.favoriteLocations[index])
            }
        }
    }
}

// MARK: - Preview
#Preview {
    FavoriteLocationsView(viewModel: WeatherViewModel())  // Provide a test ViewModel
}
