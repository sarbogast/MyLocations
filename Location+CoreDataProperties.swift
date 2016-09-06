//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Sebastien Arbogast on 05/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var date: NSTimeInterval
    @NSManaged var locationDescription: String?
    @NSManaged var category: String?
    @NSManaged var placemark: NSObject?

}
