//
//  UIView+Round.swift
//  Celebrastic
//
//  Created by German on 15/2/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

extension UIView {
    func round(){
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func roundWholeView(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func roundVeryLittle(){
        self.layer.cornerRadius = self.frame.size.width * 0.1
        self.clipsToBounds = true
    }
    
    func roundVeryLittleForHeight(height : CGFloat) {
        self.layer.cornerRadius = height / 2
        self.layer.masksToBounds = true
    }
    func cardView()  {
        self.layer.cornerRadius = Constants.consShared.THREE_INT.toCGFloat
        self.layer.shadowOffset = CGSize(width: Constants.consShared.ZERO_INT.toCGFloat, height: Constants.consShared.ZERO_INT.toCGFloat)
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }
    func cardView(_ cornerRadius:CGFloat,opacity:Float)  {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOffset = CGSize(width: Constants.consShared.ZERO_INT.toCGFloat, height: Constants.consShared.ZERO_INT.toCGFloat)
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
    
    func addblurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        sendSubview(toBack: blurEffectView)
    }
    
    func rotateViewBy270() {
        let origin = self.frame
        
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 3/2)); //270º
        self.frame = origin
    }
}
