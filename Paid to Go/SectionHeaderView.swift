//
//  SectionHeaderView.swift
//  Paid to Go
//
//  Created by Nahuel on 12/9/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static func instanceFromNib() -> SectionHeaderView {
        return UINib(nibName: "SectionHeaderView", bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first! as! SectionHeaderView
    }
    
    func configureForCommutePreferencesSection() {
        titleLabel.text = "Commute preferences:"
    }
    
    func configureForCommuteTypesSection() {
        titleLabel.text = "Commute types:"
    }

}
