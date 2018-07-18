//
//  AddOrganizationTableViewCell.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 13/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class AddOrganizationTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Constants
    static let identifier = "AddOrganizationTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.cardView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
