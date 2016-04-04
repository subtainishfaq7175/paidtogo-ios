//
//  ActivitySimpleCell.swift
//  Paid to Go
//
//  Created by Germán Campagno on 29/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import YYWebImage
import YYImage

class PoolCell: UITableViewCell {
    
    
    // MARK: - IBOutletm
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var poolImageView: UIImageView!
    
    // MARK: - Constants
    static let identifier = "poolCell"
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        poolImageView.roundWholeView()
    }
    
    // MARK: - Configuration
    
    
    func configure(pool: Pool) {
        self.titleLabel.text = pool.text
        
        self.poolImageView.yy_setImageWithURL(
            NSURL( string: pool.imageUrl),
            options: .ProgressiveBlur )
        
    }
    
}