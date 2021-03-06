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
        self.selectedView.backgroundColor = CustomColors.carColor()
    }
    
    func deselectCell() {
        self.selectedView.backgroundColor = UIColor.lightGray
    }
    
    func configure(user: User) {
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.nameLabel.text = user.fullName()
        
        if let imageURL = user.profilePicture {
            self.profileImageView.yy_setImage(
                with: URL( string: imageURL ),
                options: .progressiveBlur )
        }
    }
}
