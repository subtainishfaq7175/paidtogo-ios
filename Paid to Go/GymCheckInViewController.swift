//
//  GymCheckInViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 31/08/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import MapKit
import ObjectMapper

class GymCheckInViewController: MenuContentViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var gymDetailView: UIView!
    
    @IBOutlet weak var checkInButton: UIButton!
    
    @IBOutlet weak var gymNameLabel: UILabel!
    @IBOutlet weak var checkInTimesLabel: UILabel!
    @IBOutlet weak var farAwayLabel: UILabel!
    
    @IBOutlet weak var tickImageView: UIImageView!
    
    var previousLocation : CLLocation?
    
    var selectedGymLocation : GymLocation?
    
    internal let kDistanceBetweenLocationsOffset = 25.0
    internal let metersPerMile = 1609.344
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(GymCheckInViewController.locationUpdated(notification:)), name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_LOCATION_UPDATED), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(GymCheckInViewController.enterCurrentGym(notification:)), name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_DID_ENTER_CURRENT_GYM), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GymCheckInViewController.exitCurrentGym(notification:)), name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_DID_EXIT_CURRENT_GYM), object: nil)
        
        addLocationsToMap()
        setupViews()
        
        GeolocationManager.sharedInstance.startLocationUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if GeolocationManager.sharedInstance.gymLocations.count == 0 {
            showAlert(text: "No Gyms added in any of your pools")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.focusOnCurrentLocation()
        }
    }
    
    
    //MARK: - Methods
    
    private func addLocationsToMap() {
        for location in GeolocationManager.sharedInstance.gymLocations {
            let annotation = GymPointAnnotation()

            annotation.title = location.name!
            annotation.gyumLocation = location
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.lattitude!, longitude: location.longitude!)
            
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            
            mapView.addAnnotation(pinAnnotationView.annotation!)
        }
    }
    
    /**
     Handles the drawing of the user's route on the map
     
     - parameter currentLocation: the user's updated current location
     */
    func addTravelSectionToMap(currentLocation:CLLocation) {
        
        if previousLocation == nil {
            previousLocation = currentLocation
            
        } else {
            
            let distanceBetweenLocations = CLLocationManager.getDistanceBetweenLocations(locA: previousLocation!, locB: currentLocation)
            
            // We set a minimum offset of X meters of distance between user's location points, to draw only those subroutes on the map
            if distanceBetweenLocations > kDistanceBetweenLocationsOffset {
                configureTravelSection(previousLocation: previousLocation!, currentLocation: currentLocation)
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
        
        mapView.add(polyline, level: .aboveRoads)
        
        self.previousLocation = currentLocation
    }
    
    func showGymDetail() {
        UIView.animate(withDuration: 2) {
            self.gymDetailView.isHidden = false
        }
    }
    
    func hideGymDetail() {
        UIView.animate(withDuration: 2) {
            self.gymDetailView.isHidden = true
        }
        
        for annotation in mapView.selectedAnnotations {
           mapView.deselectAnnotation(annotation, animated: false)
        }
    }
    
    func updateGymDetailView() {
        if let selectedGymLocation = selectedGymLocation {
            gymNameLabel.text = selectedGymLocation.name
            checkInTimesLabel.text = String(selectedGymLocation.timesCheckIns ?? 0)
            
//            checkInButton.isHidden = !selectedGymLocation.isAdayPassedTillLastChectIn()
            
            let distanceInMeters = selectedGymLocation.getDistanceFromCurentLocation()
            let distanceInFeets = Int(3.28084 * distanceInMeters)
            
            // greater than a mile
            if  distanceInFeets > 5280 {
                var miles = distanceInMeters * 0.000621371
                miles.roundToTwoDecinalPlace()
                farAwayLabel.text = "\(miles) miles Away"
            } else {
                farAwayLabel.text = "\(distanceInFeets) ft. Away"
            }
            
            if  Int(distanceInMeters) < k20MeterDistance  {
                checkInButton.setTitle("CHECK IN", for: .normal)
                checkInButton.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.501960814, alpha: 1)
            } else {
                checkInButton.setTitle("GET CLOSER TO CHECK IN", for: .normal)
                checkInButton.backgroundColor = #colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.7176470588, alpha: 1)
            }
        }
    }
    
    func setupViews() {
        customizeNavigationBarWithMenu()
        focusOnCurrentLocation()
        
        gymDetailView.cardView()
    }
    
    func focusOnCurrentLocation() {
        
        if let coor = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coor, animated: true)
        } else {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance((GeolocationManager.sharedInstance.getCurrentLocation().coordinate), 0.4 * metersPerMile, 0.4 * metersPerMile)
            mapView.setRegion(coordinateRegion, animated: true)
            
        }
    }
    
    func gymCheckIn() {
    let gymActivity = ManualActivity()
        
        gymActivity.startDate = Date()
        gymActivity.endDate = Date()
        gymActivity.type = .workout
        
        gymActivity.startLat = selectedGymLocation?.lattitude
        gymActivity.startLong = selectedGymLocation?.longitude
        
        gymActivity.endLat = selectedGymLocation?.lattitude
        gymActivity.endLong = selectedGymLocation?.longitude
        gymActivity.gymId = selectedGymLocation?.gymId
        
        showProgressHud()
        DataProvider.sharedInstance.registerActivites(ActivityMoniteringManager.sharedManager.getJSONArray(fromActivities: [gymActivity]) as [AnyObject]) { (response, error) in
            
            self.dismissProgressHud()
            
            if error == nil {
                if let activityData :ActivityNotification = Mapper<ActivityNotification>().map(JSON:response as! [String : Any]) {
                    let viewControler = StoryboardRouter.wellDoneViewController()
            
                    viewControler.activityResponse = activityData
                    viewControler.activityType = .workout
                    
                    self.navigationController?.pushViewController(viewControler, animated: true)
                    
                }
            } else {
                
            }
        }
    }
    
    
    //MARK: - Location Updated
    
    @objc private func locationUpdated(notification: NSNotification) {
        let currentLocation = GeolocationManager.sharedInstance.getCurrentLocation()
        addTravelSectionToMap(currentLocation: currentLocation)
        updateGymDetailView()
    }
    
    @objc private func enterCurrentGym(notification: NSNotification) {
        for annotation in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: false)
        }
        
        selectedGymLocation = GeolocationManager.sharedInstance.currentGymLocation
        updateGymDetailView()
        showGymDetail()
    }
    
    @objc private func exitCurrentGym(notification: NSNotification) {
        updateGymDetailView()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func currentPositionButtonAction(sender: AnyObject) {
        focusOnCurrentLocation()
    }
    
    @IBAction func checkInButtonAction(sender: AnyObject) {
        
        if let selectedGymLocation = selectedGymLocation {
            
            let distanceInMeters = selectedGymLocation.getDistanceFromCurentLocation()
            
            if Int(distanceInMeters) < k20MeterDistance {
              // check in here
                gymCheckIn()
            }
        }
    }
}

extension GymCheckInViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let polylineOverlay = overlay as? MKPolyline {
            let render = MKPolylineRenderer(polyline: polylineOverlay)
            
            render.strokeColor = CustomColors.greenColor()
            
            return render
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // for the blue icon
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }

//        let customPointAnnotation = annotation as! GymPointAnnotation

        let pinImage = UIImage(named: "ic_gym_pin")
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

        annotationView?.image = resizedImage

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if (view.annotation?.isKind(of: MKUserLocation.self))! {
            return
        }
        
        let customPointAnnotation = view.annotation as! GymPointAnnotation
        
        selectedGymLocation = customPointAnnotation.gyumLocation
        updateGymDetailView()
        showGymDetail()
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if !animated {
            hideGymDetail()
        }
    }
}

class GymPointAnnotation: MKPointAnnotation {
    var gyumLocation:GymLocation!
}
