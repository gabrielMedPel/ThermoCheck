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
    
    @IBAction func clearPointsTapped(_ sender: UIButton) {
        entryPoints.removeAll()
        shouldHideData = true
        updateChartData()
        DatabaseFB.shared.removeAll(callback: { err, status in
            if let err = err {
                print(err)
            }
            
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
    }
    deinit {
        EntryPoint.ref.removeAllObservers()
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
        self.title = "Combined Chart"
        
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
        set.setColor(.red)
        set.lineWidth = 3
        set.setCircleColor(.red)
        set.circleRadius = 7
        set.circleHoleRadius = 2.5
        set.fillColor = .red
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: 15, weight: .bold)
        set.valueTextColor = .black
        set.valueFormatter = BarChartValueFormatter()
        
        
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
        set.setColor(.cyan)
        set.valueTextColor = .blue
        set.valueFont = .systemFont(ofSize: 15, weight: .bold)
        set.axisDependency = .left
        set.barBorderColor = .black
        set.barBorderWidth = 0.5
        set.valueFormatter = BarChartValueFormatter()
        
        let data = BarChartData(dataSet: set)
        
        data.barWidth = 0.75
        
        return data
    }
}
extension ChartViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return entryPoints[Int(value) % entryPoints.count].dateTime
    }
}

public  class  BarChartValueFormatter :  NSObject ,  ValueFormatter {
    
    public  func  stringForValue( _  value:  Double,  entry:  ChartDataEntry,  dataSetIndex:  Int, viewPortHandler: ViewPortHandler?)  ->  String {
        return  String(Int(entry.y))
    }
}

