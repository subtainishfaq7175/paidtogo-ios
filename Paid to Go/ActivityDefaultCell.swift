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
    @IBOutlet weak var notificationImageView: UIImageView!
    
    // MARK: - Constants
    static let identifier = "activityDefaultCell"
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        notificationImageView.roundWholeView()
    }
    
    // MARK: - Configuration
    
    
    func configure(notification: Notification) {
        self.titleLabel.text = notification.text
        self.detailLabel.text = notification.detail
        
        self.notificationImageView.yy_setImageWithURL(
            NSURL( string: notification.imageUrl),
            options: .ProgressiveBlur )
        
    }
    
}