//
//  SpeedView.swift
//  Paidtogo
//
//  Created by Razi Tiwana on 06/10/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class SpeedView: UIView {
    // maximum speed of the speedometer, this can be altered to match your audience, e.g.: for sport cars set it to 300 or more, for trucks 120 would be enough (km/h)
    let clockLimitSpeed: Double = 30
    // circular progress layer to show the current speed
    let progressLayer: CAShapeLayer!
    // a gradient masking layer to achieve a progress bar with gradient colors
    var gradientMaskLayer: CAGradientLayer!
    // label that shows the current speed
    var speedLabel: UILabel = UILabel()
    // shows the speed format e.g.: km/h
    var speedFormatLabel: UILabel = UILabel()
    
    private var speedconverter :Double = 0.621371
    
    /**
     * Initializer method.
     * @param: coder - NSCoder
     */
    required init?(coder aDecoder: NSCoder) {
        progressLayer = CAShapeLayer()
        super.init(coder: aDecoder)
        setupLayers()
        setupLabels()
//        backgroundColor = .white
        //setCurrentSpeed()
    }
    
    /**
     * Lays out subviews, and makes the button rounded shaped
     */
    override func layoutSubviews() {
        layer.cornerRadius = bounds.width/2   //CGRectGetWidth(bounds)/2
        super.layoutSubviews()
    }
    
    /**
     * Current speed setter, which sets the speedLabel and the progress layer
     * @param: speed - current speed
     */
    func setCurrentSpeed(speed: Double) {
        
        let curSpeed =  speedconverter * speed
        speedLabel.text = String(format: "%.0f", arguments: [curSpeed])
        progressLayer.strokeEnd = CGFloat(curSpeed/clockLimitSpeed)
    }
    
    /**
     * Sets up both layers to show the current speed and the dashed line circle layer.
     */
    func setupLayers() {
        let startAngle = CGFloat(Double.pi/2)
        let endAngle = CGFloat(Double.pi * 2 + Double.pi/2)
        
        
        let centerPoint = CGPoint(x: bounds.width/2, y: bounds.height/2 )
        let path = UIBezierPath(arcCenter:centerPoint, radius: bounds.width/2 - 2 , startAngle:startAngle, endAngle:endAngle, clockwise: true).cgPath
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        let colorTop: AnyObject = UIColor(red: 96.0/255.0, green: 185.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor
        let colorBottom: AnyObject = UIColor(red: 91.0/255.0, green: 193.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        let arrayOfColors = [colorTop, colorBottom]
        
        gradientLayer.colors = arrayOfColors
        gradientLayer.locations = [0.0, 1.0]
        
        gradientMaskLayer = gradientLayer
        
        progressLayer.path = path
        progressLayer.backgroundColor = UIColor.clear.cgColor
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.lineWidth = 4.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        
        gradientMaskLayer.mask = progressLayer
        
        layer.addSublayer(gradientMaskLayer)
        
        let dashedLayer = CAShapeLayer()
        dashedLayer.strokeColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
        dashedLayer.fillColor = nil
        //        dashedLayer.lineDashPattern = [1, 2]
        dashedLayer.lineJoin = "round"
        dashedLayer.lineWidth = 2.0
        dashedLayer.path = progressLayer.path
        layer.insertSublayer(dashedLayer, below: gradientMaskLayer)
        
        
    }
    
    /**
     * Sets up speed and speedformat layers to show the current speed
     */
    func setupLabels() {
        
        speedLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width/2 , height: 40.0))
        speedLabel.textColor = .black
        speedLabel.textAlignment = .center
        //  print(speed)
        speedLabel.text = "0"
        speedLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30.0)
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(speedLabel)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: speedLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: speedLabel, attribute: .centerY, multiplier: 1.0, constant: 5.0))

        
        speedFormatLabel = UILabel(frame: CGRect(x: 0.0, y: speedLabel.frame.maxY + 0.5, width: frame.width , height: 20.0))
        speedFormatLabel.textColor = .black
        speedFormatLabel.textAlignment = .center
        speedFormatLabel.text = "mph"
        speedFormatLabel.font = UIFont(name: "HelveticaNeue", size: 10.0)
        speedFormatLabel.translatesAutoresizingMaskIntoConstraints = false
        //add gesture to label
        let speedFormatlabelTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.didTapUserCustomButton(_:)))
        speedFormatLabel.addGestureRecognizer(speedFormatlabelTapGesture)
        speedFormatLabel.isUserInteractionEnabled = true
        
        addSubview(speedFormatLabel)
        
        addConstraint(NSLayoutConstraint(item: speedLabel, attribute: .bottomMargin, relatedBy: .equal, toItem: speedFormatLabel, attribute: .topMargin, multiplier: 1.0, constant: -15.0))
        addConstraint(NSLayoutConstraint(item: speedLabel, attribute: .centerX, relatedBy: .equal, toItem: speedFormatLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
    }
    
    @objc func didTapUserCustomButton(_ sender: UITapGestureRecognizer) {
        
        if(speedFormatLabel.text == "kph"){
            speedFormatLabel.text = "mph"
            speedconverter = 0.621371
            
        } else {
            speedFormatLabel.text = "kph"
            speedconverter = 1.0
        }
        
    }
}
