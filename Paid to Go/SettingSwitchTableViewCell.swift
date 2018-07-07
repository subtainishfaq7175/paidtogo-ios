//
//  SettingSwitchTableViewCell.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 07/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

protocol SettingSwitchTableViewCellDelegate {
    func didChangeSwitch(state: Bool, on section:Int, and row:Int)
}

class SettingSwitchTableViewCell: UITableViewCell {

    var delegate:SettingSwitchTableViewCellDelegate?
    
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    var section = 0
    var row = 0
    
    // MARK: - Constants
    static let identifier = "SettingSwitchTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        if self.delegate != nil {
            self.delegate?.didChangeSwitch(state: sender.isOn, on: section, and: row)
        }
    }
    
    // MARK: - Configuration
    func configure(title: String) {
        self.menuTitleLabel.text = title
    }
}
