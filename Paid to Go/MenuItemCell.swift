//
//  MenuItemCell.swift
//  Care4
//
//  Created by Fernando Ortiz on 2/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell /*, Reusable*/ {
    
    // MARK: - IBOutlet
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    
    // MARK: - Constants
    static let identifier = "MenuItemCell"
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Configuration
    func configure(title: String, icon:String) {
        menuTitleLabel.text = title
        menuImageView.image = UIImage(named: icon)
    }
}
