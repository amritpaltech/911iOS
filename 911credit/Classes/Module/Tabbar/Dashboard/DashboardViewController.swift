//
//  DashboardViewController.swift
//  911credit
//
//  Created by ideveloper5 on 01/07/21.
//

import UIKit
import Charts
import MSCircularSlider
class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var reportDateLbl: UILabel!
    @IBOutlet weak var nextUpdateDateLbl: UILabel!
    @IBOutlet weak var failureView: UIView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var slider: MSGradientCircularSlider!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var meterView: MonochromeView!
    
    @IBOutlet weak var scoreDescLbl: UILabel!
    
    let months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    var pointsList : [Double] = []

    var creditReport : CreditReport?
    var historyList : [CreditReportHistory]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUserInfo()
        setUpCalendar()
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.automaticallyAdjustsScrollViewInsets = false
    }
}

// MARK: - Methods
extension DashboardViewController {
    func setupUI() {
        self.navigationItem.title = "Dashboard"
        setupMeterView()

        tableView.setContentOffset(.zero, animated: false)
        setUpCalendar()
        slider?.labelOffset = -5
        slider?.markerCount = 6
        slider?.markerColor = .white
        
        slider?.changeColor(at: 0, newColor: .red)
        slider?.changeColor(at: 1, newColor: .yellow)
        slider?.changeColor(at: 2, newColor: .green)

        slider?.angle = 200
        slider?.filledColor = .orange
        slider?.isUserInteractionEnabled = false
        slider?.handleImage = #imageLiteral(resourceName: "sliderDot")
        slider?.currentValue = 0
    }
    
    
    
    func setupMeterView() {
        self.slider.isHidden = true
    }
        
    
    func setUpCalendar() {
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
        lineChart.noDataText = "No data available!"

    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0 ..< dataPoints.count {
            dataEntries.append(ChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        lineChartDataSet.axisDependency = .left
        lineChartDataSet.setColor(UIColor.green)
        lineChartDataSet.setCircleColor(UIColor.green) // our circle will be dark red
        
        lineChartDataSet.circleHoleColor = .white
        lineChartDataSet.lineWidth = 1.0
        
        lineChartDataSet.circleHoleRadius = 2.0
        lineChartDataSet.circleRadius = 4.0 // the radius of the node circle
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.fillColor = UIColor.green
        lineChartDataSet.highlightColor = UIColor.white
        
        var dataSets = [LineChartDataSet]()
        dataSets.append(lineChartDataSet)
        
        let lineChartData = LineChartData(dataSets: dataSets)
        lineChart.data = lineChartData
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        lineChart.legend.enabled = false
        lineChart.xAxis.labelFont = UIFont.systemFont(ofSize: 7)
        
        lineChart.pinchZoomEnabled = false
        lineChart.isUserInteractionEnabled = false
        
        lineChart.xAxis.labelCount = dataPoints.count
        lineChart.xAxis.setLabelCount(dataPoints.count, force: true)
        
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.drawGridLinesEnabled = false
        lineChart.drawGridBackgroundEnabled = false
        
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
    
    func updateUI() {
        if let report = self.creditReport{
            self.reportDateLbl.text = report.reportDate
            self.nextUpdateDateLbl.text = report.nextDate
            self.scoreLbl.text = report.score
            if let intScore = Int(report.score ?? "") {
                if intScore<400 {
                    scoreDescLbl.text="POOR"
                } else if intScore<600 {
                    scoreDescLbl.text="NEEDS WORK"
                } else {
                    scoreDescLbl.text="GOOD"
                }
            }
            let doubleScore = Double(report.score ?? "") ?? 0
            let scorePerc = ((doubleScore)*100)/(900)

            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                if doubleScore >= 300 && doubleScore < 500 {
                    if doubleScore == 300 {
                        self.meterView.drawDot(value: CGFloat(0.01))
                    } else {
                        self.getAngle(min: 300, max: 499, value: doubleScore,startAngle: 0.0,endAngle: 0.20)
                    }
                } else if  doubleScore >= 500 && doubleScore < 575 {
                    self.getAngle(min: 500, max: 574, value: doubleScore,startAngle: 0.23,endAngle: 0.38)
                } else if  doubleScore >= 575 && doubleScore < 650{
                    self.getAngle(min: 575, max: 649, value: doubleScore,startAngle: 0.41,endAngle: 0.61)
                } else if  doubleScore >= 650 && doubleScore < 750 {
                    self.getAngle(min: 650, max: 749, value: doubleScore,startAngle: 0.64,endAngle: 0.79)
                } else if  doubleScore >= 750 && doubleScore <= 900 {
                    self.getAngle(min: 750, max: 900, value: doubleScore,startAngle: 0.81,endAngle: 1.0)
                }
            }
            self.slider.currentValue = scorePerc
            slider?.changeColor(at: 0, newColor: .red)
            slider?.changeColor(at: 1, newColor: .yellow)
            slider?.changeColor(at: 2, newColor: .green)
        }
        var showMonth : [String] = []
        if let list = self.historyList {
            for value in 1...months.count {
                let month = list.filter { obj in
                    let date = convertToDate(obj.scoreDate ?? "")
                    let month = getCurrentMonth(date: date) ?? 0
                    return month == value
                }.first
                let score = Double(month?.score ?? "")
                if score != nil {
                    pointsList.append(score ?? 0)
                    showMonth.append(months[value-1])
                }
            }
            print("months",showMonth)
            print("pointsList",pointsList)

            setChart(dataPoints: showMonth, values: pointsList)
        }
    }
    
    func getAngle(min:Double,max:Double,value:Double,startAngle:Double,endAngle:Double){
        let scorePerc = ((value - min)*100)/(max-min)
        var value = ((endAngle-startAngle)*scorePerc/100) + startAngle
        self.meterView.drawDot(value: CGFloat(value))

    }
    
    
    func convertToDate(_ date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date) ?? Date()
    }
    
    func getCurrentMonth(date:Date)->Int? {
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)
        let myComponents = myCalendar?.components(.month, from: date)
        let month = myComponents?.month
        return month
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
class MonthNumberFormatter: NSObject, IAxisValueFormatter {

    private let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    private var startMonthIndex:Int!

    convenience init(startMonthIndex: Int){
        self.init()
        self.startMonthIndex = startMonthIndex
    }

    private func getMonth(index: Int) -> Int{
        return (index % months.count)
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        let monthIndex:Int = self.getMonth(index: Int(value) + self.startMonthIndex)
        let month = months[monthIndex]
        return month
    }
}
