//
//  PoolSyncAlert.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 12/06/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//
import MBProgressHUD

import UIKit
struct ActivityType {
    var title = Constants.consShared.EMPTY_STR
    var id = Constants.consShared.ZERO_INT
}
protocol SyncDelegate {
    func activity(synced: Bool)
}
class PoolSyncAlert: UIView {
    static let shared = PoolSyncAlert()
    @IBOutlet weak var cancelOL: UIButton!
    @IBOutlet weak var syncOL: UIButton!
    @IBOutlet weak var activePoolLB: UILabel!
    @IBOutlet weak var pollLB: UILabel!
    @IBAction func cancelAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBAction func syncAction(_ sender: Any) {
        postActivityData()
    }
    var syncDelegate:SyncDelegate?
    var typesPV = UIPickerView()
    var poolsPV = UIPickerView()
    var pools = [ActivityType]()
    var acitvityTypes = [ActivityType]()
    var activityTypeId = Constants.consShared.ZERO_INT
    var poolID = Constants.consShared.ZERO_INT

    override func awakeFromNib() {
        cancelOL.layer.cornerRadius = cancelOL.frame.height / Constants.consShared.TWO_INT.toCGFloat
        syncOL.layer.cornerRadius = syncOL.frame.height / Constants.consShared.TWO_INT.toCGFloat
        acitvityTypes = [ActivityType(title:"Walk/Run" , id: 1), ActivityType(title:"Bicycle" , id: 2),ActivityType(title:"Workout" , id: 3)]
        activityTypeId = acitvityTypes[Constants.consShared.ZERO_INT].id
        typesPV = createPickerView()
        poolsPV = createPickerView()

        if acitvityTypes.count > Constants.consShared.ZERO_INT {
            activePoolLB.text = acitvityTypes[Constants.consShared.ZERO_INT].title
        }
        activePoolLB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gesture(_:))))
        pollLB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gesture(_:))))
        
        getActivityData()
    }
    
     func showProgressHud() {
        let loadingNotification = MBProgressHUD.showAdded(to: self, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
    }
    
     func showProgressHud(title: String) {
        let loadingNotification = MBProgressHUD.showAdded(to: self, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = title
    }
    func dismissProgressHud() {
        MBProgressHUD.hideAllHUDs(for: self, animated: true)
    }
    func postActivityData()  {
        self.showProgressHud()
        DataProvider.sharedInstance.postUserActivity(poolID, miles: HomeViewController.mileTravel ?? 0.0, steps: HomeViewController.steps ?? 0.0, activityType: activityTypeId, completion: { (data, error) in
            self.dismissProgressHud()
            
            if let error = error, error.isEmpty == false {
                if let delegate = self.syncDelegate {
                    delegate.activity(synced: false)
                }
//                self.present(self.alert(error), animated: true, completion: nil)
                
                return
            }
            
            if let data = data {
                if let delegate = self.syncDelegate {
                    delegate.activity(synced: true)
                }
                self.removeFromSuperview()
            }
        })
    }
    
    private func postActivityDataNew() {
        
    }
    
    private func getActivityData() {
        let activities = ActivityMoniteringManager.sharedManager.activityData
        
        var jsonObject: [[String : Any]] = []
        for activity in activities {
            jsonObject.append(activity.toJSON())
        }
        
        do {
            if JSONSerialization.isValidJSONObject(jsonObject) {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            }
        } catch {
            print(error)
        }
    }
    
    @objc func gesture(_ notify : UIGestureRecognizer)  {
        switch notify.view {
        case activePoolLB:
            self.addSubview(typesPV)
            break
        case pollLB:
            self.addSubview(poolsPV)
            break
        default:
            break
        }
    }
     func showAlert() {
        poolsPV = createPickerView()
        if pools.count > Constants.consShared.ZERO_INT {
        pollLB.text = AppUtils.utilsShared.getNotAvailableStr(pools[Constants.consShared.ZERO_INT].title)
            poolID = pools[Constants.consShared.ZERO_INT].id
        }
        poolsPV.reloadAllComponents()
        let windows = UIApplication.shared.windows
        let lastWindow = windows.last
        let bounds = UIScreen.main.bounds
        let frame = CGRect(x: Constants.consShared.EIGHT_INT.toCGFloat , y:  bounds.height / Constants.consShared.THREE_INT.toCGFloat, width: bounds.width - (Constants.consShared.EIGHT_INT * Constants.consShared.TWO_INT).toCGFloat , height: bounds.height / Constants.consShared.THREE_INT.toCGFloat)
        self.frame = frame
        self.layer.cornerRadius =  10.0
        lastWindow?.addSubview(self)
    }
  func removeAlert() {
        self.removeFromSuperview()
    }
    func createPickerView() -> UIPickerView {
        let pickerView = createPickerView(self.frame.width  , height: self.frame.height, tintColor: .black, backColor: UIColor.brown , xPosition: 0 , yPosition: 0)
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }
    func createPickerView(_ width:CGFloat, height:CGFloat, tintColor:UIColor, backColor:UIColor, xPosition:CGFloat, yPosition:CGFloat) -> UIPickerView  {
        let catsPV = UIPickerView()
        catsPV.backgroundColor = backColor
        catsPV.tintColor = tintColor
        catsPV.tag = Constants.consShared.HUNDRED_INT
        catsPV.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        return catsPV
    }
    
}
extension PoolSyncAlert: UIPickerViewDelegate {
    
    
}
extension PoolSyncAlert:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Constants.consShared.ONE_INT
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == typesPV {
            return acitvityTypes.count
        }
        return pools.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typesPV {
            self.activePoolLB.text = AppUtils.utilsShared.getNotAvailableStr(acitvityTypes[row].title)
            self.activityTypeId = (acitvityTypes[row].id)
            typesPV.removeFromSuperview()
            return
        }
        self.pollLB.text = AppUtils.utilsShared.getNotAvailableStr(pools[row].title)
        self.poolID = (pools[row].id)
        poolsPV.removeFromSuperview()
    }
        
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == typesPV {
            let cellView = Bundle.main.loadNibNamed(IdentifierConstants.idConsShared.GENERAL_PICKER_CELL, owner: self, options: nil)?.first as? GeneralPickerCell
            cellView?.titleLB.text = acitvityTypes[row].title
            return cellView!
        }
        let cellView = Bundle.main.loadNibNamed(IdentifierConstants.idConsShared.GENERAL_PICKER_CELL, owner: self, options: nil)?.first as? GeneralPickerCell
        cellView?.titleLB.text = pools[row].title
        return cellView!
    }
    
}
