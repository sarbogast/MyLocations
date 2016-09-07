//
//  Location.swift
//  
//
//  Created by Sebastien Arbogast on 05/09/2016.
//
//

import Foundation
import CoreData
import MapKit

class Location: NSManagedObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    var title:String? {
        if locationDescription.isEmpty {
            return "(No description)"
        } else {
            return self.locationDescription
        }
    }
    
    var subtitle: String? {
        return self.category
    }
}
