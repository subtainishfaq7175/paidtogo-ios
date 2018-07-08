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

class ActivitiesGraphViewController: UIViewController {

    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Private Methods
    
    private func setupViewController() {
        setupDropDownApperance()
        setupDurationDropDown()
        setupActivityDropDown()
        setupTagsView()
        updateChart()
    }
    
    private func setupDropDownApperance() {
        let appearance = DropDown.appearance()
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 8
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
    }
    
    private func setupActivityDropDown() {
        activityDropDown.anchorView = activityDropDownView
        activityDropDown.bottomOffset = CGPoint(x: 0, y: activityDropDownView.bounds.height)
        activityDropDown.dataSource = [
            "10 €",
            "20 €",
            "30 €",
            "40 €",
            "50 €",
            "60 €",
            "70 €",
            "80 €",
            "90 €",
            "100 €",
            "110 €",
            "120 €"
        ]
        activityDropDown.selectionAction  = { index, item in
            print(index)
            print(item)
        }
    }
    
    private func setupDurationDropDown() {
        durationDropDown.anchorView = durationDropDownView
        durationDropDown.bottomOffset = CGPoint(x: 0, y: durationDropDownView.bounds.height)
        durationDropDown.dataSource = [
            "10 €",
            "20 €",
            "30 €",
            "40 €",
            "50 €",
            "60 €",
            "70 €",
            "80 €",
            "90 €",
            "100 €",
            "110 €",
            "120 €"
        ]
        
        durationDropDown.selectionAction = { index, item in
            print(index)
            print(item)
        }
    }
    
    private func setupTagsView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func updateChart() {
        var lineChartEntries: [ChartDataEntry] = []
        
        for i in 0..<20 {
            let entry = ChartDataEntry(x: Double(i), y: Double(2 * i))
            lineChartEntries.append(entry)
        }
        
        let line = LineChartDataSet(values: lineChartEntries, label: "Label Text")
        line.colors = [.green]
        line.circleColors = [.green]
        line.drawFilledEnabled = true
        line.fillColor = .green
        
        let data = LineChartData()
        data.addDataSet(line)
        
        lineChart.data = data
        lineChart.chartDescription?.text = ""
        lineChart.backgroundColor = .white
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GraphsCollectionViewCell
        cell.titleLabel.text = "Hello I'm Tag"
        cell.backgroundColor = .white
        return cell
    }
    
    
}
