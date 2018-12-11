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
    
    func addblurView(style: UIBlurEffectStyle = .dark) {
        let blurEffect = UIBlurEffect(style: style)
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
    
    func addBorders() {
        self.borders(for: [.all])
    }
    
    func addAppThemeBorder() {
        self.borders(for: [.all], width: 2, color: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1))
    }
    
    func borders(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)) {
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }
                    
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
    
    // MARK: - Fetch all Subviews
    
    /** This is the function to get subViews of a view of a particular type
     */
    func subViews<T : UIView>(type : T.Type) -> [T] {
        var all = [T]()
        
        for view in self.subviews {
            if let aView = view as? T {
                all.append(aView)
            }
        }
        return all
    }
    
    
    /** This is a function to get subviews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T] {
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T {
                all.append(aView)
            }
            guard view.subviews.count > 0 else { return }
            view.subviews.forEach { getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}
