//
//  LocationCell.swift
//  MyLocations
//
//  Created by Sebastien Arbogast on 06/09/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import UIKit
import CoreLocation

class LocationCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var addressLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configureForLocation(location: Location) {
        if location.locationDescription.isEmpty {
            self.descriptionLabel.text = "(No description)"
        } else {
            self.descriptionLabel.text = location.locationDescription
        }
        
        if let placemark = location.placemark {
            self.addressLabel.text = stringFromPlacemark(placemark)
        } else {
            self.addressLabel.text = ""
        }
    }
    
    func stringFromPlacemark(placemark:CLPlacemark) -> String {
        
        var line1 = ""
        if let streetName = placemark.thoroughfare {
            line1 += streetName + " "
        }
        if let number = placemark.subThoroughfare {
            line1 += number
        }
        
        var line2 = ""
        if let postalCode = placemark.postalCode {
            line2 += postalCode + " "
        }
        if let city = placemark.locality {
            line2 += city
        }
        
        return line1 + ", " + line2
    }
}
