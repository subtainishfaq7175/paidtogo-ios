//
//  CarPoolInviteCell.swift
//  Paid to Go
//
//  Created by MacbookPro on 30/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import UIKit

class CarPoolInviteCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    // MARK: - Constants
    static let identifier = "carPoolInviteCell"
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        selectedView.roundWholeView()
        profileImageView.roundWholeView()
    }
    
    // MARK: - Configuration
    
    
    
    func selectCell() {
        
        if self.selected {
            selectedView.hidden = true
        } else {
            selectedView.hidden = false
        }
    }
    
    func configure(user: User) {
        self.nameLabel.text = user.fullName()
        
        if let imageURL = user.profilePicture {
            self.profileImageView.yy_setImageWithURL(
                NSURL( string: imageURL),
                options: .ProgressiveBlur )
        }
    }

}
