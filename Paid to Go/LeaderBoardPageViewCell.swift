//
//  leaderBoardPageViewCell.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 13/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import FSPagerView

class LeaderBoardPageViewCell: FSPagerViewCell {
   
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIView!
    
    @IBOutlet weak var poolNameLabel: UILabel!
    @IBOutlet weak var pointsLabel : UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var positionSuffixLabel: UILabel!
    
    // MARK: - Constants
    static let identifier = "LeaderBoardPageViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        containerView.cardView()
        profileImageView.roundWholeView()
        containerView.roundVeryLittleForHeight(height: 10)
    }
}
