//
//  Subroute.swift
//  Paid to Go
//
//  Created by Nahuel on 29/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import MapKit

class Subroute: MKPolyline {
    
    var invisible : Bool!
    
    init(invisible:Bool, coordinates coords: UnsafeMutablePointer<CLLocationCoordinate2D>, count: Int) {
        super.init()
        
        self.invisible = invisible
    }
    
    convenience init(coordinates coords: UnsafeMutablePointer<CLLocationCoordinate2D>, count: Int) {
        self.init(coordinates: coords, count: count)
    }
    
}