//
//  ViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//

import UIKit
import Charts



class ChartViewController: UIViewController {
    
    @IBOutlet weak var chartView: CombinedChartView!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var addPointButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBAction func logoutTapped(_ sender: UIButton) {
        Authentication.shared.signOut(viewController: self)
    }
    @IBAction func clearPointsTapped(_ sender: UIButton) {
        showProgress(title: "")
        entryPoints.removeAll()
        shouldHideData = true
        updateChartData()
        DatabaseFB.shared.removeAll(callback: {[weak self] err, status in
            if let err = err {
                print(err)
                self?.showError(title: "Try Again")
            }
            self?.showSuccess(title: "")
            
        })
        SQLCommands.clearEntrypoints()
    }
    @IBAction func addNewPointTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toAdd", sender: self)
    }
    
    var shouldHideData = false
    var entryPoints = [EntryPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Authentication.shared.fetchCurrentUser(viewController: self)
        
        configureChartView()
        
        addObserverOfEntryPoints()
        
        configureButtons()
    }
    deinit {
        EntryPoint.ref.removeAllObservers()
    }
    
    func configureButtons(){
        clearButton.makeRounded()
        addPointButton.makeRounded()
        logoutButton.makeRounded()
    }
    
    func addObserverOfEntryPoints(){
        EntryPoint.ref.child(Authentication.shared.getCurrentuserID()).child("entryPoints").observe(.childAdded) { [weak self] snapshot in
            
            guard let dict = snapshot.value as? [String: Any],
                  let entrypoint = EntryPoint(dict: dict)
            else {return}
            
            self?.entryPoints.append(entrypoint)
            self?.shouldHideData = false
            self?.updateChartData()
            self?.chartView.notifyDataSetChanged()
            
            print(self?.entryPoints.count ?? 0)
            print(SQLCommands.getEntryPoints()?.count ?? 0)
        }
    }
    
    func configureChartView(){
        self.title = "Thermo Chart"
        
        chartView.chartDescription.enabled = true
        chartView.drawBarShadowEnabled = false
        chartView.highlightFullBarEnabled = false
        
        chartView.extraTopOffset = 30
        let l = chartView.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let rightAxis = chartView.rightAxis
        rightAxis.axisMinimum = -10
        rightAxis.axisMaximum = 50
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 100
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        xAxis.labelRotationAngle = -40
        
        xAxis.valueFormatter = self
    }
    
    func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setChartData()
    }
    
    func setChartData() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        
        chartView.xAxis.axisMinimum = data.xMin - 0.5
        
        chartView.data = data
        chartView.animate(yAxisDuration: 2)
    }
    
    func generateLineData() -> LineChartData {
        var entries = [ChartDataEntry]()
        
        for i in 0...entryPoints.count-1{
            let entry = ChartDataEntry(x: Double(i), y: Double(entryPoints[i].temperature))
            entries.append(entry)
        }
        
        let set = LineChartDataSet(entries: entries, label: "Temperature")
        set.setColor(UIColor(named: "chartYellow")!)
        set.lineWidth = 3
        set.setCircleColor(UIColor(named: "chartYellow")!)
        set.circleRadius = 7
        set.circleHoleRadius = 2.5
        set.fillColor = UIColor(named: "chartYellow")!
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: 15, weight: .bold)
        set.valueTextColor = UIColor(named: "chartYellowText")!
        set.valueFormatter = BarChartValueFormatterTemperature()
        set.axisDependency = .right
        
        let data = LineChartData(dataSet: set)
        
        return data
    }
    
    func generateBarData() -> BarChartData {
        var entries = [BarChartDataEntry]()
        
        for i in 0...entryPoints.count-1{
            let entry = BarChartDataEntry(x: Double(i), y: Double(entryPoints[i].humidity))
            entries.append(entry)
        }
        
        let set = BarChartDataSet(entries: entries, label: "Humidity")
        set.setColor(UIColor(named: "chartBlue")!)
        set.valueTextColor = UIColor(named: "chartBlueText")!
        set.valueFont = .systemFont(ofSize: 15, weight: .bold)
        set.axisDependency = .left
        set.barBorderColor = .black
        set.barBorderWidth = 0.5
        set.valueFormatter = BarChartValueFormatterHumidity()
        
        
        let data = BarChartData(dataSet: set)
        data.barWidth = 0.75
        
        return data
    }
}
extension ChartViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var str = entryPoints[Int(value) % entryPoints.count].dateTime
        str.insert("\n", at: str.index(str.startIndex, offsetBy: 10))
        return str
    }
}

public  class  BarChartValueFormatterTemperature :  NSObject ,  ValueFormatter {
    
    public  func  stringForValue( _  value:  Double,  entry:  ChartDataEntry,  dataSetIndex:  Int, viewPortHandler: ViewPortHandler?)  ->  String {
        return  String(Int(entry.y)) + "°C"
    }
}

public  class  BarChartValueFormatterHumidity :  NSObject ,  ValueFormatter {
    
    public  func  stringForValue( _  value:  Double,  entry:  ChartDataEntry,  dataSetIndex:  Int, viewPortHandler: ViewPortHandler?)  ->  String {
        return  String(Int(entry.y)) + "%"
    }
}

