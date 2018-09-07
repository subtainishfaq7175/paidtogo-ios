//
//  ActivityTableViewCell.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 12/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var walkingView: UIView!
    @IBOutlet weak var cyclingView: UIView!
    @IBOutlet weak var workoutView: UIView!
    
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var earningsView: UIView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var earningsLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var totalCaloriesBurnedLabel: UILabel!
    @IBOutlet weak var totalCO2OffsetLabel: UILabel!
    @IBOutlet weak var totalGasSavedLabel: UILabel!
    
    @IBOutlet weak var walkingCaloriesBurnedLabel: UILabel!
    @IBOutlet weak var walkingCO2OffsetLabel: UILabel!
    @IBOutlet weak var walkingGasSavedLabel: UILabel!

    @IBOutlet weak var cyclingCaloriesBurnedLabel: UILabel!
    @IBOutlet weak var cyclingCO2OffsetLabel: UILabel!
    @IBOutlet weak var cyclingGasSavedLabel: UILabel!

    @IBOutlet weak var workoutCaloriesBurnedLabel: UILabel!
    @IBOutlet weak var workoutCO2OffsetLabel: UILabel!
    @IBOutlet weak var workoutGasSavedLabel: UILabel!
    
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var workotMinLabel: UILabel!
    
    
    // MARK: - Constants
    static let identifier = "ActivityTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        workoutView.cardView()
        totalView.cardView()
        walkingView.cardView()
        cyclingView.cardView()
        
        pointsView.round()
        earningsView.round()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
