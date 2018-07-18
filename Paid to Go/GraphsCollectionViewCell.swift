//
//  GraphsCollectionViewCell.swift
//  Paid to Go
//
//  Created by Muhammad Khaliq Rehman on 08/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class GraphsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Constants
    static let identifier = "GraphsCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.roundVeryLittleForHeight(height: 10)
    }
    
    func updateView(with state:Bool) {
        self.backgroundColor = (state) ? #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.titleLabel.textColor = (state) ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
}
