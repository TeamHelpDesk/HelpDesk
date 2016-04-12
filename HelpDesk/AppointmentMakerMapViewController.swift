//
//  AppointmentMakerMapViewController.swift
//  HelpDesk
//
//  Created by Michael Madans on 4/10/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AppointmentMakerMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager!
    var annotation = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
    }
    /*
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }*/
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    

    @IBAction func onPress(sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.locationInView(mapView)
        let coordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        annotation.coordinate = coordinate
        annotation.title = "Meeting Location"
        mapView.addAnnotation(annotation)
        let alert = UIAlertController(title: "Location Set", message: "Is this where you want to set your meeting location?", preferredStyle: .Alert)
        let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
            (_)in
            self.performSegueWithIdentifier("unwindToApptMaker", sender: self)
        })
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {
            (_)in
        })
        alert.addAction(YesAction)
        alert.addAction(NoAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
