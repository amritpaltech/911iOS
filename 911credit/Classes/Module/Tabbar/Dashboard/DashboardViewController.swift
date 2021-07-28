//
//  DashboardViewController.swift
//  911credit
//
//  Created by ideveloper5 on 01/07/21.
//

import UIKit
import Charts
class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var reportDateLbl: UILabel!
    @IBOutlet weak var nextUpdateDateLbl: UILabel!
    @IBOutlet weak var failureView: UIView!
    
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]

    var creditReport : CreditReport?
    var historyList : [CreditReportHistory]?
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        setupUI()
        setUpCalendar()
    }
}

// MARK: - Methods
extension DashboardViewController {
    func setupUI() {
        self.navigationItem.title = "Dashboard"
        setUpCalendar()
    }
    
    func setUpCalendar(){
        lineChart.delegate = self
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(true)
        lineChart.pinchZoomEnabled = true
        
        let leftAxis = lineChart.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 900
        leftAxis.axisMinimum = 300
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        lineChart.rightAxis.enabled = false


    }
}

// MARK: - API's
extension DashboardViewController {
    func getUserInfo() {
        if let value = UserDefaults.standard.value(forKey: "unauthorized") as? Bool,value{
            failureView.isHidden = false
            return
        }
        failureView.isHidden = true
        Utils.showSpinner()
        APIServices.getUserInfo {(list, code) in
            Utils.hideSpinner()
            if code == "100" {
                AppDelegate.shared?.setupSecurityQuestion()
            } else {
                //load dashboard data
                self.creditReport = list?.creditReport
                self.historyList = list?.creditReportHistory
                self.updateUI()
            }
        }
    }
    
    func updateUI(){
        if let report = self.creditReport{
            self.reportDateLbl.text = report.reportDate
            self.nextUpdateDateLbl.text = report.nextDate
        }
    }
}

// MARK: - Actions
extension DashboardViewController {
    
    @IBAction func openQuestion(_ sender: Any) {
    }
}

extension DashboardViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected");
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected");
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
}
//extension DashboardViewController: AxisValueFormatter {
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return months[Int(value) % months.count]
//    }
//}
