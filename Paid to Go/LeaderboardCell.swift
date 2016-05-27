//
//  LeaderboardCell.swift
//  Paid to Go
//
//  Created by MacbookPro on 27/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import YYWebImage
import YYImage

class LeaderboardCell: UITableViewCell {
    
    
    // MARK: - IBOutlet
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // MARK: - Constants
    static let identifier = "leaderboardCell"
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        profileImageView.roundWholeView()
    }
    
    // MARK: - Configuration
    
    
    func configure(leaderboard: Leaderboard) {
        self.titleLabel.text = "\(leaderboard.firstName!) \(leaderboard.lastName!)"
        
        if let imageURL = leaderboard.profilePicture {
            self.profileImageView.yy_setImageWithURL(
                NSURL( string: imageURL),
                options: .ProgressiveBlur )
        }
    }
    
}