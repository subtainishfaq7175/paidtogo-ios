//
//  ActivityDetailViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 8/8/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import MapKit

class ActivityDetailViewController: ViewController {

    // MARK: - IBOutlets -
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var emptyRouteView: UIView!
    @IBOutlet weak var emptyRouteLabel: UILabel!
    
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    // MARK: - Variables and constants -
    
    internal let metersPerMile = 1609.344
    
    var activityRoute : [ActivitySubroute]?
    var activity : ActivityNotification?
    
    // MARK: - View life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Activity Detail"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initLayout()
        
        // Configure Map
        configureMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Configure UI -
    
    func initLayout() {
        self.statsView.backgroundColor = CustomColors.carColor()
        
        if let miles = activity?.milesTraveled {
            milesLabel.text = "\(miles) miles"
        } else {
            milesLabel.text = "0 miles"
        }
        
        if var gas = activity?.savedGas {
            if gas == "" {
                gas = "0"
            }
            
            gasLabel.text = "\(gas) gal"
        }
        
        if var co2 = activity?.savedCo2 {
            if co2 == "" {
                co2 = "0"
            }
            
            co2Label.text = "\(co2) Metric tons"
        }
        
        if var cal = activity?.savedCalories {
            if cal == "" {
                cal = "0"
            }
            
            caloriesLabel.text = "\(cal) cal"
        }
        
        if let earnedMoney = activity?.earnedMoney {
            if earnedMoney == "0" {
                earnedLabel.text = "$0.00"
            } else {
                earnedLabel.text = "$\(earnedMoney)"
            }
        } else {
            earnedLabel.text = "$0.00"
        }
        
        if let startDate = activity?.startDateTime {
            startDateLabel.text = "\(NSDate.getDateStringWithFormatddMMyyyyHHmmss(dateString: startDate))"
        }
        
        if let endDate = activity?.endDateTime {
            endDateLabel.text = "\(NSDate.getDateStringWithFormatddMMyyyyHHmmss(dateString: endDate))"
        }
    }
    
    func configureMap() {
        guard let _ = self.activityRoute else {
            // No Activity Route
            print("No hay subroutes")
            return
        }
        
        self.emptyRouteView.isHidden = true
        self.emptyRouteLabel.isHidden = true
        
        self.mapView.delegate = self
        configureMapRegion()
        addSubroutesToMap()
    }
    
    func configureMapRegion() {
        
        let initialSubroute = self.activityRoute?.first
        let initialLatitude = Double((initialSubroute?.latitude)!)
        let initialLongitude = Double((initialSubroute?.longitude)!)
        
        let coordinate = CLLocationCoordinate2DMake(initialLatitude!, initialLongitude!)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 0.5 * metersPerMile, 0.5 * metersPerMile)
        
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func addSubroutesToMap() {
        
        guard let subroutes = self.activityRoute else {
            return
        }
        
        var previousCoordinate = CLLocationCoordinate2D()
        var nextCoordinate = CLLocationCoordinate2D()
        var invisible : String
        
        print("Hay por lo menos 1 subroute")
        
        if subroutes.count > 0 {
            
            if subroutes.count == 1 {
                
                let subroute = self.activityRoute!.first
                previousCoordinate = subroute!.getCoordinates()
                nextCoordinate = previousCoordinate
                invisible = subroute!.invisible!
                
                var coordinates = [
                    previousCoordinate,
                    nextCoordinate
                ]
                
                let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
                polyline.title = "0"
                mapView.add(polyline, level: .aboveRoads)
                
                return
            }
            
            for index in 0..<((self.activityRoute?.count)!/*-1*/) {
                
                let subroute = self.activityRoute![index]
                
                if index == 0 {
                    previousCoordinate = subroute.getCoordinates()
                    invisible = subroute.invisible!
                } else {
                    nextCoordinate = subroute.getCoordinates()
                    
                    var coordinates = [
                        previousCoordinate,
                        nextCoordinate
                    ]
                    
                    let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
                    polyline.title = subroute.invisible
                    mapView.add(polyline, level: .aboveRoads)
                    
                    previousCoordinate = nextCoordinate
                }
                
            }
        }
    }

}

extension ActivityDetailViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if let polylineOverlay = overlay as? MKPolyline {
            let invisible = polylineOverlay.title
            let render = MKPolylineRenderer(polyline: polylineOverlay)
            
            render.strokeColor = CustomColors.greenColor()
            
            if invisible! == "0" {
                render.strokeColor = CustomColors.greenColor()
            } else {
                render.strokeColor = UIColor.clear
            }
            
            return render
        }
        return nil
    }
    
}
