//
//  ViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import Charts



class ChartViewController: UIViewController {

    @IBOutlet weak var chartView: CombinedChartView!

    @IBAction func addNewPointTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toAdd", sender: self)
    }
    
    var shouldHideData = false
    var entryPoints = [EntryPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Authentication.shared.fetchCurrentUser(viewController: self)
        
        configureChartView()
        
        EntryPoint.ref.child(Authentication.shared.getCurrentuserID()).child("entryPoints").observe(.childAdded) { [weak self] snapshot in
            
            guard let dict = snapshot.value as? [String: Any],
                  let entrypoint = EntryPoint(dict: dict)
                  else {return}
            
            
            
            
            self?.entryPoints.append(entrypoint)
            
            print(self?.entryPoints.count)
            print(self?.entryPoints[0].date)
            
            
            self?.updateChartData()
            self?.chartView.notifyDataSetChanged()
        }
    }
    deinit {
        EntryPoint.ref.removeAllObservers()
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
        
        xAxis.valueFormatter = self
        
    }
    
    func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }

        self.setChartData()
        print("CHART UPDATED \(entryPoints.count)")
    }
    
    func setChartData() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        
        
//        chartView.xAxis.axisMaximum = data.xMax + 0.5
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
        set.valueFont = .systemFont(ofSize: 15)
        set.valueTextColor = .black
        
        set.axisDependency = .right
        
        
        
        return LineChartData(dataSet: set)
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
        set.valueFont = .systemFont(ofSize: 15)
        set.axisDependency = .left
        set.barBorderColor = .black
        set.barBorderWidth = 0.5
        
        
        let data = BarChartData(dataSet: set)
        
        data.barWidth = 0.75
        
        return data
    }


}
extension ChartViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return entryPoints[Int(value) % entryPoints.count].date + " " + entryPoints[Int(value) % entryPoints.count].hour
    }
}

