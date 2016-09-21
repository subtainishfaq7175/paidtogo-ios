//
//  MapViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 25/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: ViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testLabelRejected: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // MARK: - Variables and constants
    
    internal let kMapAnnotationIdentifier = "locationPoint"
    internal let kDistanceBetweenLocationsOffset = 25.0
    internal let metersPerMile = 1609.344
    
    let geocoder = CLGeocoder()
    
    var locationManager : CLLocationManager!
    var locationCoordinate : CLLocationCoordinate2D!
    
    var route : MKRoute!
    var source : MKMapItem!
    var destination : MKMapItem!
    
//    var subroutes = [MKPolyline]()
//    var mapIsMainScreen = false
    
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
     *  Configures the map's pin with the app's main color
     */
    private func configureMapPin() -> UIImage {
        let mapPin = UIImage(named: "ic_map")?.imageWithRenderingMode(.AlwaysTemplate)
        return (mapPin?.maskWithColor(CustomColors.greenColor()))!
    }
    
    private func configureMapRegion() {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance((locationManager.location?.coordinate)!, 0.5 * metersPerMile, 0.5 * metersPerMile)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func addSubroutesToMap() {
        
        let subroutes = ActivityManager.getSubroutes()
        
        if subroutes.count > 0 {
            for subroute in subroutes {
                mapView.addOverlay(subroute, level: .AboveRoads)
            }
        }
    }
    
    private func addAnnotationsToMap() {
        /*
        let mapAnnotation = MapAnnotation(coordinate: ActivityManager.sharedInstance.endLocation.coordinate, title: "Final Location", subtitle: "")
        mapView.addAnnotation(mapAnnotation)
        mapView.reloadInputViews()
         */
    }
    
    func addTravelSectionToMap(currentLocation:CLLocation) {
        
        let previousLocation = ActivityManager.getLastSubrouteInitialLocation()
        let distanceBetweenLocations = CLLocationManager.getDistanceBetweenLocations(previousLocation, locB: currentLocation)
        
        if ActivityManager.isMapMainScreen() {
            distanceLabel.text = String(format: "%.2f", distanceBetweenLocations)
        }
        
        if distanceBetweenLocations > 10.0 {
            
//            ActivityManager.updateMilesCounter(currentLocation)
            ActivityManager.updateMilesCounterWithMeters(distanceBetweenLocations)
            
            var coordinates = [
                previousLocation.coordinate,
                currentLocation.coordinate
            ]
            
            let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
            
            polyline.title = "0"
            if ActivityManager.hasPausedAndResumedActivity() == true && ActivityManager.isFirstSubrouteAfterPausingAndResumingActivity() == true {
                polyline.title = "1"
                ActivityManager.setFirstSubrouteAfterPausingAndResumingActivity(false)
            }
            
            ActivityManager.addSubroute(polyline)
            ActivityManager.setLastSubrouteInitialLocation(currentLocation)
            ActivityManager.setTestCounter()
            
            if ActivityManager.isMapMainScreen() {
                mapView.addOverlay(polyline, level: .AboveRoads)
                testLabel.text = String(ActivityManager.getTestCounter())
            }
            
        } else {
            ActivityManager.setTestCounterRejected()
            if ActivityManager.isMapMainScreen() {
                testLabelRejected.text = String(ActivityManager.getTestCounterRejected())
            }
        }
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(MapAnnotation) {
            
            var mapAnnotationView = MKAnnotationView()
            
            if let mapAnnotView : MKAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(kMapAnnotationIdentifier) as MKAnnotationView? {
                mapAnnotationView = mapAnnotView
            } else {
                mapAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: kMapAnnotationIdentifier)
            }
            
            mapAnnotationView.enabled = true
            mapAnnotationView.canShowCallout = true
            
            mapAnnotationView.image = configureMapPin()
            
            return mapAnnotationView
            
        } else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if let polylineOverlay = overlay as? MKPolyline {
            let invisible = polylineOverlay.title
            let render = MKPolylineRenderer(polyline: polylineOverlay)
            
            if invisible! == "0" {
                render.strokeColor = CustomColors.greenColor()
            } else {
                render.strokeColor = UIColor.clearColor()
            }
            
            return render
        }
        return nil

    }
    
}

/*
 private func addRouteToMap() {
 //        self.showProgressHud("Loading map...")
 
 //  - Draws one line on the map between two points -
 
 /*var coordinates = [
 (locationManager.location?.coordinate)!,
 ActivityManager.sharedInstance.endLocation.coordinate
 ]
 
 let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
 
 mapView.addOverlay(polyline, level: .AboveRoads)*/
 
 
 //  - Draws one road on the map from the user's current location to the final destination -
 
 let initialLocation = locationManager.location!
 let endLocation = ActivityManager.sharedInstance.endLocation
 
 // Initial location
 geocoder.reverseGeocodeLocation(initialLocation) { (placemarks, error) in
 if placemarks?.count > 0 {
 if let initialmkPlacemark = self.getMKPlacemarkFromCLPlacemark(placemarks![0]) as MKPlacemark? {
 self.source =  MKMapItem(placemark: initialmkPlacemark)
 
 // Final location
 self.geocoder.reverseGeocodeLocation(endLocation) { (placemarks, error) in
 if let finalmkPlacemark = self.getMKPlacemarkFromCLPlacemark(placemarks![0]) as MKPlacemark? {
 self.destination =  MKMapItem(placemark: finalmkPlacemark)
 
 // Route between locations
 self.fetchRoute()
 }
 }
 }
 }
 }
 }
 */

/*
 private func getMKPlacemarkFromCLPlacemark(clPlacemark:CLPlacemark) -> MKPlacemark? {
 if let addressDict = clPlacemark.addressDictionary as! [String:AnyObject]? {
 if let location = clPlacemark.location as CLLocation? {
 
 let mkPlacemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: addressDict)
 return mkPlacemark
 }
 }
 
 return nil
 }
 */

/*
 private func fetchRoute() {
 let request:MKDirectionsRequest = MKDirectionsRequest()
 
 // Source and destination are the relevant MKMapItems
 request.source = source
 request.destination = destination
 
 // Specify the transportation type
 request.transportType = MKDirectionsTransportType.Automobile;
 
 // If you're open to getting more than one route,
 // requestsAlternateRoutes = true; else requestsAlternateRoutes = false;
 request.requestsAlternateRoutes = true
 
 let directions = MKDirections(request: request)
 
 directions.calculateDirectionsWithCompletionHandler ({
 (response: MKDirectionsResponse?, error: NSError?) in
 
 self.dismissProgressHud()
 
 if error == nil {
 let directionsResponse = response
 // Get whichever currentRoute you'd like, ex. 0
 self.route = directionsResponse!.routes[0] as MKRoute
 
 // Add route to map
 self.mapView.addOverlay(self.route.polyline, level: MKOverlayLevel.AboveRoads)
 }
 })
 }
 */