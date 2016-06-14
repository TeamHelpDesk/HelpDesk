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
import GoogleMaps

class AppointmentMakerMapViewController: UIViewController{
    
    //@IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var marker = GMSMarker()
    var lat: Double!
    var long: Double!
    var mapView: GMSMapView!
    @IBOutlet weak var closeButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let camera = GMSCameraPosition.cameraWithLatitude(40.773376,
                                                          longitude: -73.949447, zoom: 17)
    
        self.mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        
        self.view = self.mapView
        self.view.addSubview(self.closeButton)

        NSLayoutConstraint(item: closeButton,
                           attribute: .Leading,
                           relatedBy: .Equal,
                           toItem: view,
                           attribute: .LeadingMargin,
                           multiplier: 1.0,
                           constant: 10.0).active = true
        
        NSLayoutConstraint(item: closeButton,
                           attribute: .Top,
                           relatedBy: .Equal,
                           toItem: view,
                           attribute: .LeadingMargin,
                           multiplier: 1.0,
                           constant: 20.0).active = true
        
        let margins = view.layoutMarginsGuide
        
        closeButton.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        closeButton.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
 
        self.view.bringSubviewToFront(self.closeButton)
    
        let press = UILongPressGestureRecognizer(target: self, action: #selector(AppointmentMakerMapViewController.onPress(_:)))
        self.mapView.userInteractionEnabled = true
        self.mapView.addGestureRecognizer(press)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
   /* func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }*/
    
    
    func onPress(sender: UILongPressGestureRecognizer? = nil) {
        print("longpress")
        let coordinate = mapView.camera.target
        marker.position = coordinate
        lat = coordinate.latitude
        long = coordinate.longitude
        marker.title = "Meeting Location"
        marker.map = mapView
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
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

// MARK: - CLLocationManagerDelegate
extension AppointmentMakerMapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            mapView.settings.compassButton = true
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
        
    }
}
