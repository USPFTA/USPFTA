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

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var beginButton: UIButton!
    
    var manager:CLLocationManager!
    
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
        lpgr.minimumPressDuration = 2
        mapView.addGestureRecognizer(lpgr)
        
        let circle = MKCircle(centerCoordinate: geofenceCoord, radius: geofenceRadius)
        mapView.addOverlay(circle)
        
    }
    
    func dropFlag(gestureRecognizer: UIGestureRecognizer) {
        
        println("dropFlag")
        
        if gestureRecognizer.state != UIGestureRecognizerState.Began {
            return
        }
    
        let touchPoint = gestureRecognizer.locationInView(self.mapView) // self?
        let touchMapCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView) // self?
        var annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoord
        annotation.title = "Your Flag"
        
        mapView.addAnnotation(annotation)
        userFlagCoords = touchMapCoord
        
        beginButton.hidden = false
        
        println("flag dropped")
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        // TODO: set region to geofence
        let spanX = 0.05
        let spanY = 0.05
        var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }

    @IBAction func beginGame(sender: AnyObject) {
        
        
        
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
