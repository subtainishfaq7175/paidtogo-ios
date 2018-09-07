//
//  LinkOrganizationVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 10/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class LinkOrganizationVC: BaseVc {

    @IBOutlet weak var organizationTV: UITableView!
    @IBOutlet weak var organizationSearch: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    
//    var invitations = [Invitations]()
    var pools = [Pool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        organizationTV.register(UINib(nibName: idConsShared.ORGANIZATION_TVC, bundle: nil), forCellReuseIdentifier: idConsShared.ORGANIZATION_TVC)
        organizationTV.estimatedRowHeight = Constants.consShared.HUNDRED_INT.toCGFloat
        // Do any additional setup after loading the view.
        getEligiblePools()
        
        self.title = "Enter Pools"
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Enter pools"
        searchController.searchBar.delegate = self
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
            navigationItem.titleView = searchController.searchBar
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getEligiblePools()  {
        self.showProgressHud()
        
        DataProvider.sharedInstance.getEligiblePools((User.currentUser?.userId)!) { (pools, error) in
            self.dismissProgressHud()
            if let error = error, error.isEmpty == false {
                self.present(self.alert(error), animated: true, completion: nil)
                return
            }
            
            if error == nil && pools != nil {
                self.pools = pools!
                self.organizationTV.reloadData()
                print("\(String(describing: pools))")
            }
            
        }
    }
  
}

extension LinkOrganizationVC : UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getEligiblePools()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            searchPools(withQuery: query)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchPools(withQuery searchQuery: String)  {
        
        self.showProgressHud()
        
        DataProvider.sharedInstance.searchPools(withSearchString: searchQuery, poolType: "public_pool", completion: { (pools, error) in
            self.dismissProgressHud()
            if let error = error, error.isEmpty == false {
                self.present(self.alert(error), animated: true, completion: nil)
                return
            }
            
            if error == nil && pools != nil {
                self.pools = pools!
                self.organizationTV.reloadData()
                print("\(String(describing: pools))")
            }
        })
    }
}

// MARK: - searchbar delegate
extension LinkOrganizationVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

// MARK: - uitableview datsource and delegate

extension LinkOrganizationVC : UITableViewDelegate{
    
}

extension LinkOrganizationVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pools.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idConsShared.ORGANIZATION_TVC, for: indexPath) as! OrganizationTVC
        cell.selectionStyle = .none
        
        if let id = pools[indexPath.row].id {
             cell.poolId =  Int(id)
        }
        
        if let pooltype = pools[indexPath.row].poolType {
            
            switch pooltype {
            case .Private :
                cell.poolTypelabel.text = "Private"
                break
            case .Public :
                cell.poolTypelabel.text = "Public"
                
            case .National:
                cell.poolTypelabel.text = "National"
                break
            }
        }
        
        if let company = pools[indexPath.row].name, company != consShared.EMPTY_STR {
            cell.companyNameLB.text = company
        }else {
            cell.companyNameLB.text = "Not available"
        }
        if let country = pools[indexPath.row].country , country != consShared.EMPTY_STR{
            cell.countryLB.text = country
        }else {
            cell.countryLB.text = "Not available"
        }
        if let url = pools[indexPath.row].banner {
            //            MARK: - NEED TO GET COMPLETE URL FROM SERVER
            let  completeUrl = "https://www.paidtogo.com/images/pools/"+url
            cell.bannerIV.yy_setImage(with: URL(string:completeUrl), placeholder: #imageLiteral(resourceName: "ic_paidtogo"), options: .showNetworkActivity, completion: { (image, url, type, stage, error) in
                
            })

        }
        cell.parentVC = self
        return cell
    }
}
