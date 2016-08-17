//
//  ViewController.swift
//  Memorable Places
//
//  Created by Aly Yakan on 8/16/16.
//  Copyright © 2016 Aly Yakan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

var places = [Dictionary<String, String>()]

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if activePlace == -1 {
            
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            
        } else {
            
            let latitude = Double(places[activePlace]["lat"]!)!
            let longitude = Double(places[activePlace]["lon"]!)!
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate.longitude = longitude
            annotation.coordinate.latitude = latitude
            
            annotation.title = places[activePlace]["name"]
            
            let latDelta: CLLocationDegrees = 0.01
            
            let lonDelta: CLLocationDegrees = 0.01
            
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            self.map.setRegion(region, animated: true)
            
            map.addAnnotation(annotation)
            
            map.showsScale = true
            
            
        }
        
        
        
        let uilgpr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.saveLocation(_:)))
        
        uilgpr.minimumPressDuration = 1
        
        map.addGestureRecognizer(uilgpr)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        getUserLocation(locations[0])
        
        print("Location Updated")
    
        locationManager.stopUpdatingLocation()
        
    }
    
    func saveLocation(gestureRecognizer: UIGestureRecognizer) {
        
        print("Location Saved")
        if (gestureRecognizer.state == UIGestureRecognizerState.Began){
            /*
             The if condition restricts the save to only once, at the beginning, since the Long Press is a continious gesture and will execute continiously unless it is restricted by its state.
             */
            
            let touchPoint = gestureRecognizer.locationInView(self.map)
            
            let newCoordinate: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks!.count > 0 {
                    let pm = CLPlacemark(placemark: placemarks![0])
                    var subThoroughfare: String = ""
                    var thoroughfare: String = ""
                    if pm.subThoroughfare != nil {
                        subThoroughfare = pm.subThoroughfare!
                    }
                    if pm.thoroughfare != nil {
                        thoroughfare = pm.thoroughfare!
                    }
                    let locationDesc: String = "\(subThoroughfare) \(thoroughfare) \(pm.country!)"
                    
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = newCoordinate
                    
                    self.map.addAnnotation(annotation)
                    
                    annotation.title = locationDesc
                    
                    places.append(["name": locationDesc, "lat": "\(newCoordinate.latitude)", "lon": "\(newCoordinate.longitude)"])
                    NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
        }
        
        
        
    }
    
    func getUserLocation(loc: CLLocation) {
        
        let userLocation: CLLocation = loc
        
        let lat = userLocation.coordinate.latitude
        
        let lon = userLocation.coordinate.longitude
        
        let latDelta: CLLocationDegrees = 0.01
        
        let lonDelta: CLLocationDegrees = 0.01
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.map.setRegion(region, animated: true)
        
    }

    @IBAction func updateLocation(sender: AnyObject) {
        
        locationManager.startUpdatingLocation()
        
    }
    

}

