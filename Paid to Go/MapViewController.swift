//
//  MapViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 25/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import MapKit

enum SubrouteType : String {
    case Visible = "0"
    case Invisible = "1"
}

class MapViewController: ViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testLabelRejected: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var testHorizontalAccuracy: UILabel!
    
    // MARK: - Variables and constants
    
    internal let kMapAnnotationIdentifier = "locationPoint"
    internal let kDistanceBetweenLocationsOffset = 25.0
    internal let metersPerMile = 1609.344
    
    var locationManager : CLLocationManager?
    
    var previousLocation : CLLocation?
    var currentLocation : CLLocation?
    
    var testCounter = 0
    var testCounterRejected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureMap()
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(closeButtonPressed))
        gesture.direction = .Down
        topView.addGestureRecognizer(gesture)
        topView.userInteractionEnabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        ActivityManager.setMapIsMainScreen(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map Configuration
    
    private func configureMap() {
        mapView.delegate = self
        
        configureMapRegion()
        addSubroutesToMap()
    }
    
    /**
     *  Centers the map on the user's current location
     */
    private func configureMapRegion() {
        
        if let locationManager = self.locationManager {
             let coordinateRegion = MKCoordinateRegionMakeWithDistance((locationManager.location?.coordinate)!, 0.5 * metersPerMile, 0.5 * metersPerMile)
            
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
    }
    
    private func addSubroutesToMap() {
        
        let subroutes = ActivityManager.getSubroutes()
        
        if subroutes.count > 0 {
            for subroute in subroutes {
                mapView.addOverlay(subroute, level: .AboveRoads)
            }
        }
    }
    
    /**
     Handles the drawing of the user's route on the map
     
     - parameter currentLocation: the user's updated current location
     */
    func addTravelSectionToMap(currentLocation:CLLocation) {
        
        let previousLocation = ActivityManager.getLastSubrouteInitialLocation()
        let distanceBetweenLocations = CLLocationManager.getDistanceBetweenLocations(previousLocation, locB: currentLocation)
        
        // Test
        if ActivityManager.isMapMainScreen() {
            distanceLabel.text = String(format: "%.2f", distanceBetweenLocations)
            testHorizontalAccuracy.text = String(format: "%.2f", currentLocation.horizontalAccuracy)
        }
        
        // We set a minimum offset of 20 meters of distance between user's location points, to draw only those subroutes on the map
        if distanceBetweenLocations > 20.0 {
            
            // Update travelled miles by the user
            ActivityManager.updateMilesCounterWithMeters(distanceBetweenLocations)
            
            configureTravelSection(previousLocation, currentLocation: currentLocation)
            
        } else {
            ActivityManager.setTestCounterRejected()
            if ActivityManager.isMapMainScreen() {
                testLabelRejected.text = String(ActivityManager.getTestCounterRejected())
            }
        }
    }
    
    /**
     Draws the subroutes on the map
     
     - parameter previousLocation: user's last location
     - parameter currentLocation:  user's current location
     */
    func configureTravelSection(previousLocation:CLLocation, currentLocation:CLLocation){
        
        var coordinates = [
            previousLocation.coordinate,
            currentLocation.coordinate
        ]
        
        let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        
        // Verifies if the subroute must or must not be visible
        if ActivityManager.subrouteShouldBeInvisible() {
            polyline.title = SubrouteType.Invisible.rawValue
            ActivityManager.setFirstSubrouteAfterPausingAndResumingActivity(false)
        } else {
            polyline.title = SubrouteType.Visible.rawValue
        }
        
        // If the map is on screen, the subroute is added. Otherwise, it will be drawn when the map screen is loaded
        if ActivityManager.isMapMainScreen() {
            mapView.addOverlay(polyline, level: .AboveRoads)
            testLabel.text = String(ActivityManager.getTestCounter())
        }
        
        ActivityManager.addSubroute(polyline)
        
        ActivityManager.setLastSubrouteInitialLocation(currentLocation)
        ActivityManager.setTestCounter()
    }
    
    // MARK: - IBActions
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func currentPositionButtonAction(sender: AnyObject) {
        self.mapView.setCenterCoordinate(ActivityManager.getLastLocation().coordinate, animated: true)
    }
    
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if let polylineOverlay = overlay as? MKPolyline {
            let render = MKPolylineRenderer(polyline: polylineOverlay)
            
            if let invisible = polylineOverlay.title {
                if invisible == SubrouteType.Visible.rawValue {
                    render.strokeColor = CustomColors.greenColor()
                } else {
                    render.strokeColor = UIColor.clearColor()
                }
            }
            
            return render
            
        }
        return nil

    }
    
}
