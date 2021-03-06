//
//  TableViewHeader.swift
//  Paid to Go
//
//  Created by Nahuel on 2/8/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

protocol TableViewHeaderConfiguration {
    func configureForPools(color:String)
    func configureForActivities()
    func configureForLeaderboardsList()
    func configureForLeaderboards()
}

class TableViewHeader: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var attributeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        if let view = Bundle.main.loadNibNamed(String(describing: TableViewHeader()), owner: self, options: nil)!.first as? UIView {
//            self.addSubview(view)
//            view.frame = self.bounds
//        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

extension TableViewHeader: TableViewHeaderConfiguration {
    
    func configureForPools(color:String) {
        self.titleLabel.text = "Pool Name"
        self.backgroundColor = UIColor.darkGray
        titleLabel.textColor = UIColor.white
        attributeLabel.textColor = UIColor.white
    }
    
    func configureForActivities() {
        self.titleLabel.text = "Pool Name"
        self.attributeLabel.text = "Miles Travelled"
        self.titleLabel.textColor = UIColor.white
        self.attributeLabel.textColor = UIColor.white
        self.backgroundColor = CustomColors.headerColor()
    }
    
    func configureForLeaderboardsList() {
        self.titleLabel.text = "Pool Name"
        self.attributeLabel.text = "Position"
        self.titleLabel.textColor = UIColor.white
        self.attributeLabel.textColor = UIColor.white
        self.backgroundColor = CustomColors.headerColor()
    }
    
    func configureForLeaderboards() {
        self.titleLabel.text = "Username"
        self.attributeLabel.text = "Position"
        self.titleLabel.textColor = UIColor.darkGray
        self.attributeLabel.textColor = UIColor.darkGray
    }
}
