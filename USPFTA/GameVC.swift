//
//  GameVC.swift
//  USPFTA
//
//  Created by Mollie on 3/7/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit

let proximity:Double = 400 // meters

class GameVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let sampleData: [[String:AnyObject]] = [ // other players' flags
        ["latitude": 33.7586630800343, "longitude": -84.3826462453672, "objective": "Photo"],
        ["latitude": 33.7566878966899, "longitude": -84.3937825443492, "objective": "Audio"],
        ["latitude": 33.7522435697036, "longitude": -84.3845765360579, "objective": "Video"],
        ["latitude": 33.751688015529, "longitude": -84.3946734474182, "objective": "Statue"],
        ["latitude": 33.7390326877359, "longitude": -84.3870265212676, "objective": "Monument"],
        ["latitude": 33.7518114731818, "longitude": -84.3839826006786, "objective": "Playground"],
        ["latitude": 33.7558237411146, "longitude": -84.399127967011, "objective": "Football helmet"],
        ["latitude": 33.7645266335291, "longitude": -84.387620459479, "objective": "Milkshake"],
        ["latitude": 33.7560706417568, "longitude": -84.3885113611318, "objective": "Anything"]
    ]

    @IBOutlet weak var mapView: MKMapView!
    
    var manager:CLLocationManager!
    var userLocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        let circle = MKCircle(centerCoordinate: geofenceCoord, radius: geofenceRadius)
        mapView.addOverlay(circle)
        
        // center and zoom map
        let circleRegion = MKCoordinateRegionMakeWithDistance(geofenceCoord, geofenceRadius * 4, geofenceRadius * 4)
        let adjustedRegion = mapView.regionThatFits(circleRegion)
        mapView.setRegion(adjustedRegion, animated: true)
        
        // add flags to map
        
        for location in sampleData as [[String:AnyObject]] {
            
            let annotation = MKPointAnnotation()
            let latitude = location["latitude"] as CLLocationDegrees
            let longitude = location["longitude"] as CLLocationDegrees
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            annotation.coordinate = coordinate
            annotation.title = location["objective"] as String
            mapView.addAnnotation(annotation)
            
        }

    }
    
    // hide callout of user location
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        userLocation.title = ""
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let userLoc = userLocation {
            
            if annotation.coordinate.latitude == userLoc.coordinate.latitude && annotation.coordinate.longitude == userLoc.coordinate.longitude {
                return nil
            }
            
        }
        
        // only run this code if it's a pin--not the circle
        if annotation.coordinate.latitude == geofenceCoord.latitude && annotation.coordinate.longitude == geofenceCoord.longitude {
            return nil
        } else {
            
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView.image = UIImage(named: "flag")
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            
            return annotationView
            
        }
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor(red:0, green:0.6, blue:0, alpha:1)
            circle.fillColor = UIColor(red:0, green:0.6, blue:0, alpha:0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        // TODO: don't check this every second, but only once the user has moved a certain distance
        
        userLocation = locations[0] as CLLocation
        
        for location in sampleData as [[String:AnyObject]] {
            
            let latitude = location["latitude"] as CLLocationDegrees
            let longitude = location["longitude"] as CLLocationDegrees
            let flagLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            if userLocation.distanceFromLocation(flagLocation) < proximity {
                
                let notification = UILocalNotification()
                notification.fireDate = nil
                notification.alertBody = "You are near a flag."
                //            notification.alertAction = "View List"
                //            notification.soundName = "Glass.aiff"
                
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                
                
            }
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        // TODO: change VC class
        let vc = storyboard.instantiateViewControllerWithIdentifier("cameraVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
        
    }

}
