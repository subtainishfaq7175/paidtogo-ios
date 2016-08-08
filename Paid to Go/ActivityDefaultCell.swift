//
//  ActivitySimpleCell.swift
//  Paid to Go
//
//  Created by Germán Campagno on 29/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import YYWebImage
import YYImage

class ActivityDefaultCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notificationImageView: UIImageView!
    
    // MARK: - Constants
    static let identifier = "activityDefaultCell"
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
    }
    
    override func layoutSubviews() {
        notificationImageView.roundWholeView()
    }
    
    // MARK: - Configuration
    
    func configure(notification: ActivityNotification) {
        
        self.titleLabel.text = notification.name
        self.dateLabel.text = notification.startDateTime?.substringToIndex(11)
        self.detailLabel.text = notification.milesTraveled! + " mi."
        
        if let imageURL = notification.iconPhoto {
        
        self.notificationImageView.yy_setImageWithURL(
            NSURL(string: imageURL),
            options: .ProgressiveBlur )
        }
    }
    
}