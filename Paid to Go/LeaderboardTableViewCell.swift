//
//  leaderboardTableViewCell.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 13/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

    // MARK: - Outlets
//    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var positionSuffixLabel: UILabel!
    
    // MARK: - Constants
    static let identifier = "LeaderboardTableViewCell"
    
    // MARK: - Variables
    var row :Int = 0
    var delegate:BalanceTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.roundWholeView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
