//
//  HistoryVC.swift
//  Tutorial
//
//  Created by Wishfin on 12/09/19.
//  Copyright © 2019 Ved. All rights reserved.
//

import UIKit
import Charts

class HistoryVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet var chartView: LineChartView!
    @IBOutlet weak var cibilScoreLabel: UILabel!
    @IBOutlet weak var scrHistory: UIScrollView!
    
    //MARK: - Variables
    var historyArray = [HistoryModel]()
    var cibilScore = ""
    var mobileNo = ""

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setHisRefresh()
        getHistoryApi()
    }
    
    func setHisRefresh() {
        scrHistory.refreshControl = UIRefreshControl()
        scrHistory.refreshControl?.addTarget(self, action:#selector(refreshHistory),for: .valueChanged)
    }
    
    @objc func refreshHistory() {
        DispatchQueue.main.async {
            self.scrHistory.refreshControl?.endRefreshing()
        }
        getHistoryApi()
    }
    
    /// Setting View
    func setupView(){
        self.scrHistory.isHidden = false
        cibilScoreLabel.text = self.cibilScore
        chartView.setScaleEnabled(false)
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 900
        leftAxis.axisMinimum = 600
        leftAxis.labelAlignment = .left
        let totalRange = 900 - 600
        let interval = 100
        leftAxis.setLabelCount(Int(totalRange/interval) + 1, force: true)
        chartView.rightAxis.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.leftAxis.drawGridLinesEnabled = false
        self.updateChartData()
        chartView.animate(xAxisDuration: 0.5)
    }
    
     func updateChartData() {
        self.setDataCount(1, range: 1)
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        var cibilArray = [Int]()
        var monthArray = [String]()
        var month = ""
        for i in (0..<historyArray.count){
            let model = historyArray[i]
            cibilArray.append(model.cibilScore)
            var dateString = model.dateModel.date
            if dateString.count > 9{
                dateString = String(dateString.prefix(10))
            }
            let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.zzzz"
            //dateFormatter.locale = Locale.init(identifier: "en_GB")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateObj = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "MMM"
            if let newDate = dateObj{
                month = dateFormatter.string(from: newDate)
            }
            monthArray.append(month)
        }
        let reversedCibil : [Int] = Array(cibilArray.reversed())
        let reversedMonth : [String] = Array(monthArray.reversed())
        var score = [ChartDataEntry]()
        for (index, element) in reversedCibil.enumerated() {
            score.append(ChartDataEntry(x: Double(index), y: Double(element), icon: nil))
        }
        let set1 = LineChartDataSet(entries:score, label: "")
        set1.drawIconsEnabled = false
        set1.setColor(CommonMethods.hexStringToUIColor(hex: "00BDAA"))
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 8)
        let gradientColors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.49).cgColor,#colorLiteral(red: 0, green: 0.7411764706, blue: 0.6666666667, alpha: 1).cgColor ]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        set1.drawFilledEnabled = true
        let data = LineChartData(dataSet: set1)
        chartView.data = data
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: reversedMonth)
        for set in chartView.data!.dataSets as! [LineChartDataSet] {
            set.mode = (set.mode == .cubicBezier) ? .linear : .cubicBezier
        }
        chartView.setNeedsDisplay()
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: Get Api call
extension HistoryVC {
    func getHistoryApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            let firstUrl = UrlName.baseUrl + UrlName.historyScore
            let secondUrl = "mobile=\(mobileNo)"
            let getUrl = firstUrl + secondUrl
            let headers = ["Authorization": Defaults.getHeader()]

            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    if let responseArray = jsonValue["result"]?.arrayValue {
                        if responseArray.count > 0 {
                            self.historyArray.removeAll()
                            if responseArray.count>8{
                                for index in 0...7 {
                                    let country = responseArray[index]
                                    self.historyArray.append(HistoryModel(json: country))
                                }
                            }
                            else {
                                for country in responseArray{
                                    self.historyArray.append(HistoryModel(json: country))
                                }
                            }
                            self.setupView()
                        }
                    }
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
}

extension HistoryVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.getHistoryApi()
            }
            else {
              //  self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
