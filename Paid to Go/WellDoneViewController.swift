//
//  WellDoneViewController.swift
//  Paid to Go
//
//  Created by Germán Campagno on 4/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class WellDoneViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backgroundColorView: UIView!
    
    // MARK: - Variables and Constants
    
    var type: Pools?
    
    // MARK: -  Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "shareSegue":
            let shareViewController = segue.destinationViewController as! ShareViewController
            shareViewController.type = self.type!
            break
        case "leaderboardsSegue":
            let wdLeaderboardsViewController = segue.destinationViewController as! WDLeaderboardsViewController
            wdLeaderboardsViewController.type = self.type!
        default:
            break
        }
        
        
    }
    
    // MARK: - Functions
    
    private func initLayout() {
        setNavigationBarVisible(true)
        clearNavigationBarcolor()
        self.title = "menu_home".localize()
        
        setPoolColor(backgroundColorView, type: type!)
        
    }
    
    
    private func initViews() {
    }
    
    // MARK: - Actions
    
//    @IBAction func showLeaderboards(sender: AnyObject) {
//        //        let leaderboardsViewController = leaderboardsNavigationController.viewControllers[0] as! LeaderboardsViewController
//        //        let leaderboardsViewController = StoryboardRouter.leaderboardsMainViewController()
//        
//        let leaderboardsViewController = StoryboardRouter.leaderboardsStoryboard().instantiateViewControllerWithIdentifier("leaderboardsViewController") as! LeaderboardsViewController
//        leaderboardsViewController.calledFromMenu = false
//
//        self.presentViewController(leaderboardsViewController, animated: true, completion: nil)
//
//    }
    
    @IBAction func backToHome(sender: AnyObject) {
        self.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}