//
//  ActivityMoniteringViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 6/28/18.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import KDCircularProgress

class ActivityMoniteringViewController: ViewController {

    // MARK: - IBOutlets -
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
//    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var circularProgressCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
    @IBOutlet weak var progressLabel: UILabel!
//    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stepCountLabel: UILabel!
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBarWithTitleAndMenu()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
