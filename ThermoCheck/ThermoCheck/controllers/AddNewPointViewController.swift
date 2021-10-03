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
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let date = dateTextField.text else { return  }
        guard let hour = hourTextField.text else { return  }
        guard let temperature = temperatureTextField.text else { return }
        guard let humidity = humidityTextField.text else { return  }

        let entryPoint = EntryPoint(date: date, hour: hour, temperature: Int(temperature) ?? 0, humidity: Int(humidity) ?? 0)
        
        saveFirebase(entryPoint: entryPoint)
       

    }
    
    func saveSQL(entryPoint: EntryPoint){
        DatabaseSQL.shared.createtable()
        SQLCommands.insert(entryPoint)
    }
    func saveFirebase(entryPoint: EntryPoint){
       

        entryPoint.save { [weak self] error, status in
            if let error = error {
                print(error)
                return
            }else{
                print("EntryPointSaved!!!!!")
                self?.saveSQL(entryPoint: entryPoint)

                self?.dismiss(animated: true)
            }

        }
    }
    
   
    @IBOutlet weak var humidityTextField: UITextField!
   
    @IBOutlet weak var temperatureTextField: UITextField!
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGauge()
        addTargetToTextFields()
        

    }
    
    func ringStokeColor(gaugeView: GaugeView, value: Double) -> UIColor {
        if gaugeView.maxValue == 100{
            return .blue
        }else{
            return .red
        }
    }

    
    func addTargetToTextFields(){
        temperatureTextField.addTarget(self, action: #selector(tempTextFieldDidChange), for: .editingChanged)
        humidityTextField.addTarget(self, action: #selector(humiTextFieldDidChange), for: .editingChanged)
    }
    
    @objc
    func tempTextFieldDidChange(){
        var tempNum = Double(temperatureTextField.text ?? "") ?? 0
        if temperatureTextField.isNumber(){
            temperatureGauge.value = tempNum
            if tempNum < -10 {
                temperatureTextField.text = "-10"
            }
            if tempNum > 50 {
                temperatureTextField.text = "50"

            }
        }else{
            temperatureTextField.text?.removeAll()
        }
        
    }
    
    @objc
    func humiTextFieldDidChange(){
        var humiNum = Double(humidityTextField.text ?? "") ?? 0

        if humidityTextField.isNumber(){
            humidityGauge.value = humiNum
            if humiNum < 0 {
                humidityTextField.text = "0"
            }
            if humiNum > 100 {
                humidityTextField.text = "100"

            }
            
        }else{
            humidityTextField.text?.removeAll()
        }

    }
    
    func configureGauge(){
        temperatureGauge.minValue = -10
        temperatureGauge.maxValue = 50
        temperatureGauge.numOfDivisions = 0
        temperatureGauge.unitOfMeasurement = "°C"
        temperatureGauge.showMinMaxValue = false
        
        
        temperatureGauge.valueTextColor = .red
        temperatureGauge.delegate = self
        
        humidityGauge.minValue = 0
        humidityGauge.maxValue = 100
        humidityGauge.numOfDivisions = 0

        
        humidityGauge.unitOfMeasurement = "%"
        humidityGauge.showMinMaxValue = false

        
        humidityGauge.valueTextColor = .blue
        humidityGauge.delegate = self

    }
    

   

}
