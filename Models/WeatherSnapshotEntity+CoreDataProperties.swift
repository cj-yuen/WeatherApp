//
//  WeatherSnapshotEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by user268934 on 11/23/24.
//
//

import Foundation
import CoreData


extension WeatherSnapshotEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherSnapshotEntity> {
        return NSFetchRequest<WeatherSnapshotEntity>(entityName: "WeatherSnapshotEntity")
    }

    @NSManaged public var time: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var locationName: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var temperature: Double
    @NSManaged public var precipitation: Double
    @NSManaged public var precipitationProbability: Int

}
