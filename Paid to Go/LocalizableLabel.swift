//
//  localizableLabel.swift
//  Celebrastic
//
//  Created by Admin on 3/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

import UIKit

class LocalizableLabel: UILabel {
    
    @IBInspectable var localizableKey: String? {
        didSet {
            if let key = localizableKey {
                self.text = String(key: key)
            }
        }
    }
    
    
}