//
//  GenCustomView.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 03/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
class GenCustomView : UIView{
    @IBInspectable var roundedPixels:CGFloat = Constants.consShared.ZERO_INT.toCGFloat{
        didSet{
            self.layer.cornerRadius = roundedPixels
        }
    }
    @IBInspectable var isCircle:Bool = false
    override func awakeFromNib() {
        if isCircle {
            self.layer.cornerRadius = self.frame.size.width / Constants.consShared.TWO_INT.toCGFloat
        }
    }
}





