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
    
    override func viewWillAppear(animated: Bool) {
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
        
        if var miles = activity?.milesTraveled {
            if miles == "" {
                miles = "0"
            }
            
            milesLabel.text = "\(miles) miles"
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
            earnedLabel.text = "$\(earnedMoney)"
        } else {
            earnedLabel.text = "$0.00"
        }
        
        if let startDate = activity?.startDateTime {
            startDateLabel.text = "\(NSDate.getDateStringWithFormatddMMyyyy(startDate))"
        }
        
        if let endDate = activity?.endDateTime {
            endDateLabel.text = "\(NSDate.getDateStringWithFormatddMMyyyy(endDate))"
        }

    }
    
    func configureMap() {
        guard let activityRoute = self.activityRoute else {
            // No Activity Route
            return
        }
        
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
                mapView.addOverlay(polyline, level: .AboveRoads)
                
                return
            }
            
            for index in 0..<((self.activityRoute?.count)!-1) {
                
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
                    mapView.addOverlay(polyline, level: .AboveRoads)
                    
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
                render.strokeColor = UIColor.clearColor()
            }
            
            return render
        }
        return nil
    }
    
}