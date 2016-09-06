//
//  LeaderboardsListTableViewCell.swift
//  Paid to Go
//
//  Created by Nahuel on 14/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class LeaderboardsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgPool: UIImageView!
    @IBOutlet weak var imgArrow: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblSuffix: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgPool.round()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithLeaderboardsResponse(leaderboardsResponse : LeaderboardsResponse) {
        
        if let name = leaderboardsResponse.name as String? {
            self.lblTitle.text = name
        }
        
        if let imageURLString = leaderboardsResponse.iconPhoto as String? {
            let imageURL = NSURL(string: imageURLString)
            self.imgPool.yy_setImageWithURL(imageURL, options: .ProgressiveBlur)
        }
        
        if let leaderboards = leaderboardsResponse.leaderboard as [Leaderboard]? {
            if let leaderboard = leaderboards.first as Leaderboard? {
                if let place = leaderboard.place as Int? {
                    self.lblPosition.text = String(place)
                    self.lblSuffix.text = place.ordinal
                }
            }
        }
    }
    
    func configureCellWithLeaderboard(leaderboard : Leaderboard) {
        
        self.imgArrow.hidden = true
        
        if let firstName = leaderboard.firstName, lastName = leaderboard.lastName {
            self.lblTitle.text = firstName + " " + lastName
        }
        
        if let imageURLString = leaderboard.profilePicture {
            let imageURL = NSURL(string: imageURLString)
            self.imgPool.yy_setImageWithURL(imageURL, options: .ProgressiveBlur)
        }
        
        if let place = leaderboard.place {
            self.lblPosition.text = String(place)
            self.lblSuffix.text = place.ordinal
        }
        
        if let leaderboardID = leaderboard.userId, userID = User.currentUser?.userId {
            if leaderboardID == userID {
                print("Posicion del usuario")
                self.backgroundColor = CustomColors.lightGrayColor()
            }
        }
    }
}
