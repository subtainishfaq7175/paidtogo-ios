//
//  BalanceTableViewCell.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 13/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

protocol BalanceTableViewCellDelegate {
    func seeFullHistory(at row:Int)
}

class BalanceTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var poolNameLabel: UILabel!
    @IBOutlet weak var pointsOrEarningLabel : UILabel!
    @IBOutlet weak var firstActivityLabel: UILabel!
    @IBOutlet weak var secondActivityLabel: UILabel!
    
    // MARK: - Constants
    static let identifier = "BalanceTableViewCell"
    
    // MARK: - Variables
    var row :Int = 0
    var delegate:BalanceTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.cardView()
        pointsView.roundVeryLittleForHeight(height: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     // MARK: - Actions
    @IBAction func seeFullhistory(_ sender: UISwitch) {
        if delegate != nil {
            delegate?.seeFullHistory(at: row)
        }
    }

}
