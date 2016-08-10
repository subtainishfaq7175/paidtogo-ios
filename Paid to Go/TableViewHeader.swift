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
}

class TableViewHeader: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var attributeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let view = NSBundle.mainBundle().loadNibNamed(String(TableViewHeader), owner: self, options: nil).first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

extension TableViewHeader: TableViewHeaderConfiguration {
    
    func configureForPools(color:String) {
        self.titleLabel.text = "Pool Name"
        self.backgroundColor = UIColor(rgba: color)
    }
    
    func configureForActivities() {
        self.titleLabel.text = "activities"
    }
    
}