//
//  CarPoolInviteCell.swift
//  Paid to Go
//
//  Created by MacbookPro on 30/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift

class CarPoolInviteCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    // MARK: - Constants
    static let identifier = "CarPoolInviteCell"
    
    var userSelected = false
    
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
            self.userSelected = false
            self.selectedView.backgroundColor = CustomColors.carColor()
            self.nameLabel.text = "false"
        } else {
            self.userSelected = true
            self.selectedView.backgroundColor = CustomColors.walkRunColor()
            self.nameLabel.text = "true"
        }
    }
    
    func configure(user: User) {
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.nameLabel.text = user.fullName()
        
        if let imageURL = user.profilePicture {
            self.profileImageView.yy_setImageWithURL(
                NSURL( string: imageURL),
                options: .ProgressiveBlur )
        }
    }

}
