//
//  DropFlagVC.swift
//  USPFTA
//
//  Created by Mollie on 3/6/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit

let geofenceRadius = 1609 as CLLocationDistance
let geofenceCoord = CLLocationCoordinate2DMake(33.7518732, -84.3914068)
var userFlagCoords:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)

class DropFlagVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var objectiveTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var beginButton: UIButton!
    
    var manager:CLLocationManager!
    var userLocation:CLLocation!
    
    var flagAnnotation:MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // local notifications
        // TODO: move this somewhere else, possibly
        let notificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        beginButton.hidden = true

        mapView.delegate = self
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        var lpgr = UILongPressGestureRecognizer(target: self, action: "dropFlag:")
        // TODO: play around with duration
        lpgr.minimumPressDuration = 1
        mapView.addGestureRecognizer(lpgr)
        
        let circle = MKCircle(centerCoordinate: geofenceCoord, radius: geofenceRadius)
        mapView.addOverlay(circle)
        
        // center and zoom map
        let circleRegion = MKCoordinateRegionMakeWithDistance(geofenceCoord, geofenceRadius * 4, geofenceRadius * 4)
        let adjustedRegion = mapView.regionThatFits(circleRegion)
        mapView.setRegion(adjustedRegion, animated: true)
        
    }
    
    func dropFlag(gestureRecognizer: UIGestureRecognizer) {
                
        if gestureRecognizer.state != UIGestureRecognizerState.Began {
            return
        }
        
        // remove previous flags from map and data
        if let flagAnn = flagAnnotation {
            mapView.removeAnnotation(flagAnnotation)
        }
            
        let touchPoint = gestureRecognizer.locationInView(mapView)
        let touchMapCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        var annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoord
        annotation.title = "Your Flag"
        
        println(touchMapCoord.latitude)
        println(touchMapCoord.longitude)
        
        // TODO: alert user if flag is outside geofence
        let touchMapLocation = CLLocation(latitude: touchMapCoord.latitude, longitude: touchMapCoord.longitude)
        let geofenceCenter = CLLocation(latitude: geofenceCoord.latitude, longitude: geofenceCoord.longitude)
        if touchMapLocation.distanceFromLocation(geofenceCenter) <= geofenceRadius {
            
            flagAnnotation = annotation
            mapView.addAnnotation(annotation)
            userFlagCoords = touchMapCoord
            
            // TODO: only show button when *both* the textfield is filled out and the flag is dropped. this status will need to be checked in two places
            if (objectiveTextField.text != "" && flagAnnotation != nil) {
                beginButton.hidden = false
            }
            
        } else {
            
            // alert
            displayGeofenceAlert()
            
        }
        
    }
    
    func displayGeofenceAlert() {
        
        let alertController = UIAlertController(title: "Tap location is outside range. Please place a flag within the playing field.", message: nil, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // hide callout of user location
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        userLocation.title = ""
        
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
    
    // minimize keyboard on tap outside
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
        
        // TODO: only show button when *both* the textfield is filled out and the flag is dropped. this status will need to be checked in two places
        if (objectiveTextField.text != "" && flagAnnotation != nil) {
            beginButton.hidden = false
        }
        
    }

    @IBAction func beginGame(sender: AnyObject) {
        
        // double-check that they have both a flag and text
        // probably a job for back-end
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
