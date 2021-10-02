//
//  AddNewPointViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 02/10/2021.
//

import UIKit
import LMGaugeViewSwift

class AddNewPointViewController: UIViewController, GaugeViewDelegate {
    
    @IBOutlet weak var temperatureGauge: GaugeView!
    @IBOutlet weak var humidityGauge: GaugeView!
    
    func ringStokeColor(gaugeView: GaugeView, value: Double) -> UIColor {
        return .red
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        temperatureGauge.minValue = -10
        temperatureGauge.maxValue = 50
        
        temperatureGauge.unitOfMeasurement = "Temperature"
        
        humidityGauge.minValue = 0
        humidityGauge.maxValue = 100
        
        humidityGauge.unitOfMeasurement = "Humidity %"

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
