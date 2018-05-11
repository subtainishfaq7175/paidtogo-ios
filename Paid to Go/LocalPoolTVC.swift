//
//  LocalPoolTVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 03/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class LocalPoolTVC: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var itemStatusLB: UILabel!
    @IBOutlet weak var itemValueLB: UILabel!
    @IBOutlet weak var selectionView: UILabel!
    @IBOutlet weak var itemTitleLB: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var itemIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.cardView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
