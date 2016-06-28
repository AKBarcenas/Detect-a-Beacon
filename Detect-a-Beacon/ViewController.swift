//
//  ViewController.swift
//  Detect-a-Beacon
//
//  Created by Alex on 6/28/16.
//  Copyright © 2016 Alex Barcenas. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    // The label that display the distance reading for the beacon.
    @IBOutlet weak var distanceReading: UILabel!
    // The location manager for the app.
    var locationManager: CLLocationManager!

    /*
     * Function Name: viewDidLoad
     * Parameters: None
     * Purpose: This method sets up the location manager and request for location authorization.
     *   This method also sets the color of the background.
     * Return Value: None
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        view.backgroundColor = UIColor.grayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     * Function Name: locationManager
     * Parameters: manager - the location manager that is handling this method.
     *   status - the new location authoriztion status of this app.
     * Purpose: This method checks to see if location authorization has been given and starts scanning for beacons.
     * Return Value: None
     */
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    /*
     * Function Name: startScanning
     * Parameters: None
     * Purpose: This method specifies what beacon the app will be looking for and relays that information to
     *   the location manager.
     * Return Value: None
     */
    
    func startScanning() {
        let uuid = NSUUID(UUIDString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    /*
     * Function Name: updateDistance
     * Parameters: distance - the distance to the beacon.
     * Purpose: This method checks the distance to the beacon and updates the background
     *   and text of the app accordingly.
     * Return Value: None
     */
    
    func updateDistance(distance: CLProximity) {
        UIView.animateWithDuration(0.8) { [unowned self] in
            switch distance {
            case .Unknown:
                self.view.backgroundColor = UIColor.grayColor()
                self.distanceReading.text = "UNKNOWN"
                
            case .Far:
                self.view.backgroundColor = UIColor.blueColor()
                self.distanceReading.text = "FAR"
                
            case .Near:
                self.view.backgroundColor = UIColor.orangeColor()
                self.distanceReading.text = "NEAR"
                
            case .Immediate:
                self.view.backgroundColor = UIColor.redColor()
                self.distanceReading.text = "RIGHT HERE"
            }
        }
    }
    
    /*
     * Function Name: locationManager
     * Parameters: manager - the manager handling this method.
     *   beacons - the beacons that were found.
     *   region - the region that the beacons were found.
     * Purpose: This method checks to see if there are any beacons and updates the distance to these beacons.
     * Return Value: None
     */
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            updateDistance(beacon.proximity)
        } else {
            updateDistance(.Unknown)
        }
    }
}

