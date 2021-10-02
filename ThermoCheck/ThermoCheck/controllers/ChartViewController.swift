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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Combined Chart"
//        self.options = [.toggleLineValues,
//                        .toggleBarValues,
//                        .saveToGallery,
//                        .toggleData,
//                        .toggleBarBorders,
//                        .removeDataSet]
        
//        chartView.delegate = self
        
        chartView.chartDescription.enabled = false
        
        chartView.drawBarShadowEnabled = false
        chartView.highlightFullBarEnabled = false
        
        
//        chartView.drawOrder = [DrawOrder.bar.rawValue,
//                               DrawOrder.bubble.rawValue,
//                               DrawOrder.candle.rawValue,
//                               DrawOrder.line.rawValue,
//                               DrawOrder.scatter.rawValue]
        
        let l = chartView.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
//        chartView.legend = l

        let rightAxis = chartView.rightAxis
        rightAxis.axisMinimum = -10
        rightAxis.axisMaximum = 50
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 100
       
        
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bothSided
        xAxis.granularity = 1
        
//        xAxis.valueFormatter = self
        
        self.updateChartData()
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
        
        
//        chartView.xAxis.axisMaximum = data.xMax + 0.5
        chartView.xAxis.axisMinimum = data.xMin - 0.5

        
        chartView.data = data
        chartView.animate(yAxisDuration: 2)
        
        
        
        
    }
        
    func generateLineData() -> LineChartData {
        let entries = [ChartDataEntry(x: 1, y: 20), ChartDataEntry(x: 2, y:35), ChartDataEntry(x: 3, y: -5)]
        
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
        let entries = [BarChartDataEntry(x: 1, y: 30), BarChartDataEntry(x: 2, y: 80), BarChartDataEntry(x: 3, y: 60)]
        
        
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
    
    

    // Swift // // Estender a amostra de código a partir de 6a. Adicionar o Login no Facebook ao seu código // Adicione ao seu método de viewDidLoad: loginButton.permissions = ["public_profile", "email"]


}

