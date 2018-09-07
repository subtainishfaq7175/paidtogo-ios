//
//  MainStatsViewController.swift
//  Paid to Go
//
//  Created by Muhammad Khaliq Rehman on 08/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class MainStatsViewController: MenuContentViewController {

    
    //MARK: - Class Properties
    
    @IBOutlet private weak var activityGraphContainer: UIView! {
        didSet {
            activityGraphContainer.isHidden = true
        }
    }
    @IBOutlet private weak var activityListingContainer: UIView!
    
    private var rightBarButton: UIBarButtonItem?
    public var showGraph = false
    
    //MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setNavigationBarVisible(visible: true)
        customizeNavigationBarWithMenu()
//        setupRightBarButton()
        setupViewController()
        
        if showGraph {
            rightBarButtonTapped()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Private Methods
    
    private func setupRightBarButton() {
        rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "activity_graph"), style: .done, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupViewController() {
        title = "Activity"
    }
    
    
    //MARK: - Action Methods
    
    @objc private func rightBarButtonTapped() {
        activityGraphContainer.isHidden = !activityGraphContainer.isHidden
        activityListingContainer.isHidden = !activityListingContainer.isHidden
//        if activityListingContainer.isHidden {
//            rightBarButton!.image = #imageLiteral(resourceName: "activity_listing")
//        } else {
//            rightBarButton!.image = #imageLiteral(resourceName: "activity_graph")
//        }
    }
    
}
