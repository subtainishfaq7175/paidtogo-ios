//
//  MenuItemCell.swift
//  Care4
//
//  Created by Fernando Ortiz on 2/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class ActivitySimpleCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Constants
    static let identifier = "activitySimpleCell"
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Configuration
    func configure(title title: String, detail: String) {
        self.titleLabel.text = title
        self.detailLabel.text = detail
    }
    
    func configure(notification: Notification) {
        self.titleLabel.text = notification.text
        self.detailLabel.text = notification.detail
    }
}
