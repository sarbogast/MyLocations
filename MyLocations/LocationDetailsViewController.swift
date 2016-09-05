//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Sebastien Arbogast on 02/09/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class LocationDetailsViewController: UITableViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    let dateFormatter:NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    var category:String = "No Category"
    
    @IBAction func cancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .CustomView
        let image = UIImage(named: "Checkmark")?.imageWithRenderingMode(.AlwaysTemplate)
        hud.customView = UIImageView(image: image)
        hud.square = true
        hud.label.text = "Done"
        
        afterDelay(0.5) { 
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.text = ""
        categoryLabel.text = ""
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = self.placemark {
            addressLabel.text = stringFromPlacemark(placemark)
        } else {
            addressLabel.text = "No address found"
        }
        
        dateLabel.text = formatDate(NSDate())
        
        categoryLabel.text = category
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
        
        return line1 + "\n" + line2
    }
    
    func formatDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CategorySegue" {
            if let categoryPickerViewController = segue.destinationViewController as? CategoryPickerViewController {
                categoryPickerViewController.selectedCategoryName = category
                //categoryPickerViewController.categoryPickerViewControllerDelegate = self
            }
        }
    }
    
    @IBAction func categoryPickerDidPickCategory(segue: UIStoryboardSegue) {
        if segue.identifier == "PickedCategory" {
            if let controller = segue.sourceViewController as? CategoryPickerViewController {
                category = controller.selectedCategoryName
                categoryLabel.text = category
            }
        }
    }
}

extension LocationDetailsViewController: CategoryPickerViewControllerDelegate {
    func categoryPickerViewController(controller: CategoryPickerViewController, didSelectCategory category: String) {
        self.category = category
        self.categoryLabel.text = category
        self.navigationController?.popViewControllerAnimated(true)
    }
}
