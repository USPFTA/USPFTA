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
    
    var flagAnnotation:MKAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
        let touchPoint = gestureRecognizer.locationInView(self.mapView) // self?
        let touchMapCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView) // self?
        var annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoord
        annotation.title = "Your Flag"
        
        println(touchMapCoord.latitude)
        println(touchMapCoord.longitude)
        
        flagAnnotation = annotation
        mapView.addAnnotation(annotation)
        userFlagCoords = touchMapCoord
        
        // TODO: only show button when *both* the textfield is filled out and the flag is dropped. this status will need to be checked in two places
        if (objectiveTextField.text != "" && flagAnnotation != nil) {
            beginButton.hidden = false
        }
        
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
        
        // only run this code if it's a pin--not the circle
        if annotation.coordinate.latitude == geofenceCoord.latitude && annotation.coordinate.longitude == geofenceCoord.longitude {
            return nil
        } else {
            
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView.image = UIImage(named: "flag")
            annotationView.annotation = annotation
            
            return annotationView
            
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
