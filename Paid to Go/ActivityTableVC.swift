//
//  ActivityTableVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 05/06/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class ActivityTableVC: BaseVc {

    @IBOutlet weak var activityTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configTableView()  {
        guard let nib = UINib(nibName: IdentifierConstants.idConsShared.LOCAL_POOL_TVC, bundle: nil) as? UINib  else {
            print("nib not founded")
            return
        }
        activityTV.estimatedRowHeight = Constants.consShared.HUNDRED_INT.toCGFloat
        activityTV.register(nib, forCellReuseIdentifier: IdentifierConstants.idConsShared.LOCAL_POOL_TVC)
        
    }

}
extension ActivityTableVC : UITableViewDelegate {
    
}
extension ActivityTableVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consShared.THREE_INT
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / consShared.THREE_INT.toCGFloat
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierConstants.idConsShared.LOCAL_POOL_TVC, for: indexPath) as! LocalPoolTVC
        cell.selectionStyle = .none
        return cell
    }
}
