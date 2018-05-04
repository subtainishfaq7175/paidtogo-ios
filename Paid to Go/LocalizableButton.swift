//
//  localizableLabel.swift
//  Celebrastic
//
//  Created by Admin on 3/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

import UIKit

class LocalizableButton: UIButton {
    
    @IBInspectable var localizableKey: String? {
        didSet {
            if let key = localizableKey {
                self.setTitle(String(key: key), for: .normal)
            }
        }
    }
    
    
}
