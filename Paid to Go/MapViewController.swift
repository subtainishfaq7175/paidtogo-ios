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
    
    // MARK: - Variables and constants
    
    internal let kMapAnnotationIdentifier = "locationPoint"
    internal let metersPerMile = 1609.344
    
    var locationManager : CLLocationManager!
    var locationCoordinate : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map Configuration
    
    private func configureMap() {
        mapView.delegate = self
        
        configureMapPin()
        configureMapRegion()
        addAnnotationsToMap()
    }
    
    /**
     Configures the map's pin with the app's main color
     */
    private func configureMapPin() -> UIImage {
        let mapPin = UIImage(named: "ic_map")?.imageWithRenderingMode(.AlwaysTemplate)
        return (mapPin?.maskWithColor(CustomColors.greenColor()))!
    }
    
    private func configureMapRegion() {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(locationCoordinate, 0.1 * metersPerMile, 0.1 * metersPerMile)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func addAnnotationsToMap() {

        let mapAnnotation = MapAnnotation(coordinate: ActivityManager.sharedInstance.endLocation.coordinate, title: "Final Location", subtitle: "")
        mapView.addAnnotation(mapAnnotation)
        mapView.reloadInputViews()
    }
    
    // MARK: - IBActions
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
            mapAnnotationView.calloutOffset = CGPointMake(-5.0, -5.0)
            
            mapAnnotationView.image = configureMapPin()
            
            
            return mapAnnotationView
            
        } else {
            return nil
        }
    }
    
//    func mapView(mapView: MKMapView, viewForOverlay overlay: MKOverlay) -> MKOverlayView {
//        
//         MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
//         polylineView.strokeColor = [UIColor redColor];
//         polylineView.lineWidth = 1.0;
//         return polylineView;
//    }
}