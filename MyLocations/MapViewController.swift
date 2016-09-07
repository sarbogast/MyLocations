//
//  MapViewController.swift
//  MyLocations
//
//  Created by Sebastien Arbogast on 07/09/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView:MKMapView!
    
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextObjectsDidChangeNotification, object: managedObjectContext, queue: NSOperationQueue.mainQueue()) { notification in
                if self.isViewLoaded() {
                    self.updateLocations()
                }
            }
        }
    }
    var locations = [Location]()
    
    func updateLocations() {
        mapView.removeAnnotations(locations)
        
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        locations = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Location]
        mapView.addAnnotations(locations)
    }
    
    @IBAction func showUser() {
        let center = mapView.userLocation.coordinate
        let region = MKCoordinateRegionMakeWithDistance(center, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func showLocations() {
        mapView.setRegion(regionForAnnotations(locations), animated: true)
    }
    
    func regionForAnnotations(annotations: [MKAnnotation]) -> MKCoordinateRegion {
        var region: MKCoordinateRegion
        
        switch annotations.count {
        case 0: region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        case 1:
            region = MKCoordinateRegionMakeWithDistance(annotations[0].coordinate, 1000, 1000)
        default:
            var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            for annotation in annotations {
                topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
                topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
                bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
                bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2, longitude: topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2)
            let extraSpace = 1.3
            let span = MKCoordinateSpan(latitudeDelta: extraSpace * abs(topLeftCoord.latitude - bottomRightCoord.latitude), longitudeDelta: extraSpace * abs(topLeftCoord.longitude - bottomRightCoord.longitude))
            region = MKCoordinateRegion(center: center, span: span)
        }
        
        return mapView.regionThatFits(region)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLocations()
        
        if !locations.isEmpty {
            showLocations()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocation" {
            if let navigationController = segue.destinationViewController as? UINavigationController, controller = navigationController.viewControllers[0] as? LocationDetailsViewController {
                controller.managedObjectContext = managedObjectContext
                controller.locationToEdit = sender as? Location
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let location = view.annotation as? Location {
            self.performSegueWithIdentifier("EditLocation", sender: location)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Location else {
            return nil
        }
        
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as! MKPinAnnotationView!
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.enabled = true
            annotationView.canShowCallout = true
            annotationView.animatesDrop = false
            annotationView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            
            let rightButton = UIButton(type: .DetailDisclosure)
            annotationView.rightCalloutAccessoryView = rightButton
        } else {
            annotationView.annotation = annotation
        }
        
        return annotationView
    }
}

extension MapViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
