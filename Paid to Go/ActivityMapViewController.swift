//
//  ActivityMapViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 29/08/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import MapKit

class ActivityMapViewController: ViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var speedlabel: UILabel!
    
    // MARK: - Variables and constants
    
    internal let kMapAnnotationIdentifier = "locationPoint"
    internal let kDistanceBetweenLocationsOffset = 20.0
    internal let metersPerMile = 1609.344
    
    var locationManager : CLLocationManager?
    
    var previousLocation : CLLocation?
    var currentLocation : CLLocation?
    
    var activity : ManualActivity? {
        didSet {
            updateLabels()
        }
    }
    
    var previousLocationForSettingMapRegin: CLLocation?
    
    var coordinates : [[CLLocation]] = []
    
    
    // MARK: - ViewController Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureMap()
        
        GeolocationManager.sharedInstance.startLocationUpdates()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonPressed))
        topView.addGestureRecognizer(gesture)
        topView.isUserInteractionEnabled = true
    }
    
    override func viewWillLayoutSubviews() {
           updateLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureMapRegion()
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
    
    func focusOnCurrentLocation() {
        
     
    }
    
    private func configureMapRegion() {
        if let coor = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coor, animated: true)
        } else {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance((GeolocationManager.sharedInstance.currentLocation.coordinate), 0.4 * metersPerMile, 0.4 * metersPerMile)
            mapView.setRegion(coordinateRegion, animated: true)
            
        }
    }
    
    private func addSubroutesToMap() {
        
        for coordinatesItem in coordinates {
            for coordinate in coordinatesItem {
                addTravelSectionToMap(currentLocation: coordinate)
            }
            if coordinates.last != coordinatesItem {
                 previousLocation = nil
            }
        }
    }
    
    private func add() {
        for coordinatesItem in coordinates {
            for coordinate in coordinatesItem {
                addTravelSectionToMap(currentLocation: coordinate)
            }
            if coordinates.last != coordinatesItem {
                previousLocation = nil
            }
        }
    }
    
    
    /**
     Handles the drawing of the user's route on the map
     
     - parameter currentLocation: the user's updated current location
     */
    func addTravelSectionToMap(currentLocation:CLLocation) {
        
        if previousLocation == nil {
            previousLocation = currentLocation
            previousLocationForSettingMapRegin = currentLocation
            
        } else {
            
            let distanceBetweenLocations = CLLocationManager.getDistanceBetweenLocations(locA: previousLocation!, locB: currentLocation)
            
            // We set a minimum offset of X meters of distance between user's location points, to draw only those subroutes on the map
            if distanceBetweenLocations > kDistanceBetweenLocationsOffset {
                configureTravelSection(previousLocation: previousLocation!, currentLocation: currentLocation)
                
            }
            
//           // To update location as we go
//            let distanceBetweenLocationsForSettingRegin = CLLocationManager.getDistanceBetweenLocations(locA: previousLocationForSettingMapRegin!, locB: currentLocation)
//
//            if distanceBetweenLocationsForSettingRegin > 10 * kDistanceBetweenLocationsOffset {
//                configureMapRegion()
//                previousLocationForSettingMapRegin = currentLocation
//            }
            
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
        
        
        mapView.add(polyline, level: .aboveRoads)
        
        self.previousLocation = currentLocation
    }
    
    
    func updateLabels() {
        
        if milesLabel == nil {
            return
        }
        
        if let miles = activity?.milesTraveled {
            if miles == 0.0 {
                milesLabel.text = "0 miles"
            } else {
                milesLabel.text = String(format: "%.2f", miles) + " miles"
            }
        }
        
        if let gas = activity?.traffic {
            if gas == 0.0 {
                gasLabel.text = "0 gal"
            } else {
                gasLabel.text = String(format: "%.2f", gas) + " gal"
            }
        } else {
            gasLabel.text = "0 gal"
        }
        
        if let co2 = activity?.co2Offset {
            if co2 == 0.0 {
                co2Label.text = "0 Lbs"
            } else {
                co2Label.text = String(format: "%.2f", co2) + " Lbs"
            }
        } else {
            co2Label.text = "0 Lbs"
        }
        
        if let cal = activity?.calories {
            if cal == 0.0 {
                caloriesLabel.text = "0 cal"
            } else {
                caloriesLabel.text = String(format: "%.2f", cal) + " cal"
            }
        } else {
            caloriesLabel.text = "0 cal"
        }
        
        if let steps = activity?.steps {
            stepsLabel.text = "\(steps) steps"
        } else {
            stepsLabel.text = "0 steps"
        }
        
        if let currrentSpeed = activity?.currrentSpeed {
            speedlabel.text = "\(currrentSpeed)"
        } else {
            speedlabel.text = "0"
        }
    }
    
    func showOverSpeedingAlert() {
        showAlert(text: "We have detected that you have crossed the maximum speed allowed for biking i.e \(MasterData.sharedData?.speedOnBike ?? 20) mph")
    }
    
    func showNotRidingBikeAlert() {
        showAlert(text: "We have detected that you are not riding a bike!")
    }
    
    
    // MARK: - IBActions
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func currentPositionButtonAction(sender: AnyObject) {
        configureMapRegion()
    }
}

extension ActivityMapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let polylineOverlay = overlay as? MKPolyline {
            let render = MKPolylineRenderer(polyline: polylineOverlay)
            
            render.strokeColor = CustomColors.greenColor()

            return render
            
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
}
