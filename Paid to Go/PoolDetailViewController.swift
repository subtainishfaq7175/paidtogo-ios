//
//  PoolDetailViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 20/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class PoolDetailViewController: ViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var enterPoolButton: LocalizableButton!
    @IBOutlet weak var earnedMoneyLabel: UILabel!
    
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var backgroundContentView: UIView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - Variables and constants
    
    var pool : Pool?
    var typeEnum : PoolTypeEnum?
    var poolType : PoolType?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    private func initLayout() {
        setNavigationBarVisible(true)
        clearNavigationBarcolor()
    }
    
    func configureView() {
        setPoolColorAndTitle(backgroundColorView, typeEnum: typeEnum!, type: poolType!)
        self.backgroundContentView.backgroundColor = UIColor(rgba: poolType!.color!)
        self.backgroundImageView.yy_setImageWithURL(NSURL(string: (poolType?.backgroundPicture)!), options: .ShowNetworkActivity)
        
        enterPoolButton.roundVeryLittleForHeight(50.0)
        
//        guard let earnedMoney = pool?.earnedMoneyPerMile else {
//            return
//        }
//        earnedMoneyLabel.text = earnedMoney
    }
}
