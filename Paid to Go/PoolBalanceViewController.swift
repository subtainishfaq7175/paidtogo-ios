//
//  PoolBalanceViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 13/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class PoolBalanceViewController: MenuContentViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationBarVisible(visible: true)
        customizeNavigationBarWithMenu()
        setupViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
    private func setupViewController() {
        title = "Balance"
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PoolBalanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfrows = 0;
        
        switch section {
        case 0:
            numberOfrows = 2
            break
        case 1:
            numberOfrows =  1
            break
        default:
            break
        }
        
        return numberOfrows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellToReturn: UITableViewCell? = nil
        
        switch indexPath.section {
        case 0:
            let itemCell = tableView.dequeueReusableCell(withIdentifier: BalanceTableViewCell.identifier) as! BalanceTableViewCell
            itemCell.row = indexPath.row
            itemCell.delegate = self
            
            cellToReturn = itemCell
            break
        case 1:
            let itemCell = tableView.dequeueReusableCell(withIdentifier: AddOrganizationTableViewCell.identifier) as! AddOrganizationTableViewCell
            
            cellToReturn = itemCell
            break
        default:
            break
        }
        
        cellToReturn!.selectionStyle = .none
        
        return cellToReturn!
    }
    
}

extension PoolBalanceViewController: BalanceTableViewCellDelegate {
    func seeFullHistory(at row: Int) {
        
    }
}

