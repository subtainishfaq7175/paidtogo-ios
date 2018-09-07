//
//  ActivitiesGraphViewController.swift
//  Paid to Go
//
//  Created by Muhammad Khaliq Rehman on 08/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import DropDown
import Charts

enum ActivitGraphTag : Int {
    case moneyEarned = 0
    case milesTraveled = 1
    case carMilesOffset = 2
    case caloriesSaved = 3
    case co2Offset = 4
    case totalSteps = 5
    
    static let allValues = [moneyEarned.value, milesTraveled.value, carMilesOffset.value, caloriesSaved.value, co2Offset.value, totalSteps.value]
    
    var value : String {
        switch self {
        case .moneyEarned:
            return "Money Earned"
        case .milesTraveled:
            return "Miles Traveled"
        case .carMilesOffset:
            return "Car-Miles Offset"
        case .caloriesSaved:
            return "Calories Saved"
        case .co2Offset:
            return "CO2 Offset"
        case .totalSteps:
            return "Total Steps"
        }
    }
    
    static var count :Int {return ActivitGraphTag.totalSteps.hashValue + 1}
}

enum ActivitGraphSpan : Int {
    case daily = 0
    case weekly = 1
    case monthly = 2
    
    static let allValues = [daily.value, weekly.value, monthly.value]
    
    var value : String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        }
    }
     static var count :Int {return ActivitGraphSpan.monthly.hashValue + 1}
}

class ActivitiesGraphViewController: ViewController {
    
    var selectedTag = ActivitGraphTag.moneyEarned {
        didSet {
            yAxisLabel.text = self.selectedTag.value
        }
    }
    
    var selectedSpan = ActivitGraphSpan.daily {
        didSet {
             xAxisLabel.text = self.selectedSpan.value
        }
    }
    
    var selectedPool = 0
    
//    var tags = ["Money Earned", "Miles Traveled", "Car-Miles Offset", "Calories Saved",  "CO2 Offset","Total Steps"]
//
//    var spans = ["Daily","Weekly", "Monthly"]
    
    var data = [ActivityNotification]()
    
    @IBOutlet private weak var selectedTimeLabel: UILabel!
    @IBOutlet private weak var selectedActivityLabel: UILabel!
    
    @IBOutlet private weak var yAxisLabel: UILabel!
    @IBOutlet private weak var xAxisLabel: UILabel!
    
    @IBOutlet private weak var durationDropDownView: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(durationDropDownTapped))
            durationDropDownView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet private weak var activityDropDownView: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(activityDropDownTapped))
            activityDropDownView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet private weak var tagsView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lineChart: LineChartView!
    
    private let appearance = DropDown.appearance()
    private let durationDropDown = DropDown()
    private let activityDropDown = DropDown()
    
    
    //MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViewController()
        
        selectedSpan = ActivitGraphSpan.daily
        selectedTag = ActivitGraphTag.moneyEarned
        
        lineChart.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Private Methods
    
    private func setupViewController() {
        setupCharView()
        setupTagsView()
        setupDurationDropDown()
        if Pool.pools == nil {
            getPoolData()
        } else {
            setupActivityDropDown()
            getChartData()
        }
    
        setupDropDownApperance()
      
        // testing
        self.updateChart()
        
        DropDown.startListeningToKeyboard()
        
        yAxisLabel.rotateViewBy270()
    }
    
    private func setupCharView() {
        lineChart.cardView()
    }
    
    private func setupDropDownApperance() {
        let appearance = DropDown.appearance()
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        
        appearance.cornerRadius = 16
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
    }
    
    private func setupActivityDropDown() {
        activityDropDown.anchorView = activityDropDownView
        activityDropDown.bottomOffset = CGPoint(x: 0, y: activityDropDownView.bounds.height)
        
        var nameArray = [String]()
        
        for pool in Pool.pools! {
            nameArray.append(pool.name!)
        }
        
        activityDropDown.dataSource = nameArray
            
        activityDropDown.selectionAction  = { index, item in
            print(index)
            print(item)
            self.selectedActivityLabel.text = item
            self.selectedPool = index
            self.getChartData()
        }
        
        self.selectedActivityLabel.text = Pool.pools![selectedPool].name!
        getChartData()
    }
    
    private func setupDurationDropDown() {
        durationDropDown.anchorView = durationDropDownView
        durationDropDown.bottomOffset = CGPoint(x: 0, y: durationDropDownView.bounds.height)
        durationDropDown.dataSource = ActivitGraphSpan.allValues
        
        durationDropDown.selectionAction = { index, item in
            print(index)
            print(item)
            self.selectedTimeLabel.text = item
            self.selectedSpan = ActivitGraphSpan(rawValue: index)!
            self.getChartData()
            
        }
        
        self.selectedTimeLabel.text = selectedSpan.value
    }
    
    private func setupTagsView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func updateChart() {
        
        if self.data.count == 0 {
            return
        }
        
        var lineChartEntries: [ChartDataEntry] = []
        var xValues = [String]()
        
    let data = LineChartData()
        
        var xPosition = 1;
        for activity in self.data {
            
            
            var yPostion = 0.0
            
            switch selectedTag {
            case .moneyEarned:
                yPostion = activity.earnedMoney
                break
            case .milesTraveled:
                yPostion = activity.milesTraveled
                break
            case .carMilesOffset:
                 yPostion = activity.savedTraffic
                break
            case .caloriesSaved:
                 yPostion = activity.savedCalories
                break
            case .co2Offset:
                yPostion = activity.savedCo2
                break
            case .totalSteps:
                yPostion = Double(activity.totalSteps)
                break
            }
            
//            yPostion = 10.0
            
            let entry = ChartDataEntry(x: Double(xPosition), y: Double(yPostion))
            lineChartEntries.append(entry)
            
            xValues.append(String("test"))
            xPosition = xPosition + 1
        }
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        MonthNameFormater.selectedSpan = selectedSpan
        
        lineChart.xAxis.valueFormatter = MonthNameFormater()
        lineChart.xAxis.granularity = 1.0
        
//         lineChart.
        
        lineChart.leftAxis.axisMinimum = 0
        
        let line = LineChartDataSet(values: lineChartEntries, label: selectedTag.value)
        line.colors = [.green]
        line.circleColors = [.green]
        line.circleRadius = 4
        
    
        data.addDataSet(line)
        
//        for i in 0 ..< 20 {
//            let entry = ChartDataEntry(x: Double(i), y: Double(2 * i))
//            lineChartEntries.append(entry)
//        }
        
        
        
//        line.drawFilledEnabled = true
//        line.fillColor = .green
        
        
        
        lineChart.rightAxis.enabled = false;
//        lineChart.leftAxis.drawZeroLineEnabled = true;
        
        lineChart.data = data
        lineChart.chartDescription?.text = ""
    }
    
    private func getChartData() {
        guard let userID = User.currentUser?.userId else {
            return
        }
        
        if let pools = Pool.pools
        {
        
            let poolId = pools[selectedPool].id!
            let span = selectedSpan.value

            showProgressHud()
            DataProvider.sharedInstance.getGraphData(userID, poolId: poolId.toString, span: span, completion: { (data, error) in
                self.dismissProgressHud()
                if let error = error, error.isEmpty == false {
                    
                    return
                }
                
                if let data = data {
                    var graphData = [ActivityNotification]()
                    
                    for data in data {
                        graphData.append(data)
                    }
                    
                    self.data = graphData
                    self.updateChart()
                }
                
            })
            
        }
    }
    
    func getPoolData()  {
        guard let userID = User.currentUser?.userId else {
            return
        }
        
        let startDate = Date()
        let endDate = startDate.tomorrow
        
        DataProvider.sharedInstance.getSubscribedPools (userID,startDate: startDate, endDate: endDate, completion: { (data, error) in
           
            if let error = error, error.isEmpty == false {
                
                return
            }
            
            if let data = data {
                var pools = [Pool]()
                var nationalPool:Pool?
                
                for pool in data {
                    if pool.poolType == .National {
                        nationalPool = pool
                    } else {
                        pools.append(pool)
                    }
                }
                
                if let nationalPool = nationalPool {
                    pools.insert(nationalPool, at: 0)
                }
                
                Pool.pools = pools
                self.setupActivityDropDown()
            }
            
        })
        
    }
    
    //MARK: - Action Methods

    @objc private func activityDropDownTapped() {
        activityDropDown.show()
    }
    
    @objc private func durationDropDownTapped() {
        durationDropDown.show()
    }
    
}


//MARK: - Private Collection View Methods

extension ActivitiesGraphViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ActivitGraphTag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GraphsCollectionViewCell.identifier, for: indexPath) as! GraphsCollectionViewCell
        cell.titleLabel.text = ActivitGraphTag.allValues[indexPath.row]
        cell.updateView(with: (indexPath.row == selectedTag.rawValue))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTag = ActivitGraphTag(rawValue: indexPath.row)!
        collectionView.reloadData()
        updateChart()
    }
    
}

final class MonthNameFormater: NSObject, IAxisValueFormatter {
    static var selectedSpan :ActivitGraphSpan?
    
    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        
        let index = Int (value)
        var array: [String] = []
        
        switch MonthNameFormater.selectedSpan! {
        case .daily:
            var today = Date().yesterday
            
            for _ in 0..<7 {
                array.append(today.formatedStingdd_MMM())
                today = today.yesterday
            }
            array.reverse()
            
            break
        case .weekly:
            var today = Date()
            
            for _ in 0..<4 {
                array.append(today.formatedStingdd_MMM())
                today = today.lastWeek
            }
            
            array.reverse()
            
            break
        case .monthly:
            var today = Date()
            
            for _ in 0..<12 {
                array.append(today.formatedStingMMM_YY())
                today = today.lastMonth
            }
            
            array.reverse()
            break
        }
        
        return array[index-1]
    }
}
