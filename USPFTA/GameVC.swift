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
    
    var sampleData: [[String:AnyObject]] = [ // other players' flags
        ["latitude": 33.7586630800343, "longitude": -84.3826462453672, "objective": "Take selfie with menu"],
        ["latitude": 33.7566878966899, "longitude": -84.3937825443492, "objective": "Take a photo of your receipt"],
        ["latitude": 33.7522435697036, "longitude": -84.3845765360579, "objective": "Dip your head in the fountain"],
        ["latitude": 33.751688015529, "longitude": -84.3946734474182, "objective": "Jump near CODE"],
        ["latitude": 33.7390326877359, "longitude": -84.3870265212676, "objective": "Take a picture with the cowboy"],
        ["latitude": 33.7518114731818, "longitude": -84.3839826006786, "objective": "Pose with the statue"],
        ["latitude": 33.7558237411146, "longitude": -84.399127967011, "objective": "Selfie at library circulation desk"],
        ["latitude": 33.7645266335291, "longitude": -84.387620459479, "objective": "Buy a bagel"],
        ["latitude": 33.7560706417568, "longitude": -84.3885113611318, "objective": "Selfie with street sign"]
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
        addFlags()
        
    }
    
    func addFlags() {
        
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
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        // hide callout of user location
        userLocation.title = ""
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKPointAnnotation {
            
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView.image = UIImage(named: "flag")
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            
            return annotationView
            
        }
        
        return nil
        
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
        
        var i = 0
        
        for location in sampleData as [[String:AnyObject]] {
            
            let latitude = location["latitude"] as CLLocationDegrees
            let longitude = location["longitude"] as CLLocationDegrees
            let flagLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            if userLocation.distanceFromLocation(flagLocation) < proximity {
                
                // present alert view
                displayProximityAlert(location, index: i)
                manager.stopUpdatingLocation()
                break
                
            }
            
            i++
            
        }
        
    }
    
    func displayProximityAlert(location: [String:AnyObject], index: Int) {
        
        let objective = location["objective"] as String
        
        let alertController = UIAlertController(title: "You are near a flag", message: "Take a photo that represents \"\(objective)\"", preferredStyle: .Alert)
        
        //        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
        //
        ////            // segue to whatever was tapped on:
        ////            self.tabBarController?.selectedIndex = navigatingTo
        //
        //        }
        //
        //        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
            let storyboard = UIStoryboard(name: "Camera", bundle: nil)
            // TODO: change VC class
            let vc = storyboard.instantiateViewControllerWithIdentifier("cameraVC") as CameraVC
            
            // pass flag data on to VC
            vc.flagData = location
            vc.flagIndex = index
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
        let vc = storyboard.instantiateViewControllerWithIdentifier("cameraVC") as CameraVC
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
}