//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by user268934 on 11/22/24.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    // Initialize your PersistenceController
    let persistenceController = PersistenceController.shared
    
    // Instantiate the WeatherViewModel
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext) // CoreData context
                .environmentObject(weatherViewModel) // Pass WeatherViewModel to all views
        }
    }
}
