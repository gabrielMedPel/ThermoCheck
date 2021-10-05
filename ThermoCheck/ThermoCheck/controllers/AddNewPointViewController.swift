//
//  AddNewPointViewController.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 02/10/2021.
//

import UIKit
import LMGaugeViewSwift

class AddNewPointViewController: UIViewController{
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var temperaturePicker: UIPickerView!
    @IBOutlet weak var humidityPicker: UIPickerView!
    
    @IBOutlet weak var temperatureGauge: GaugeView!
    @IBOutlet weak var humidityGauge: GaugeView!
    
    var temperatureValues = [Int]()
    var humidityValues = [Int]()
    
    var temperatureSelected = -20
    var humiditySelected = 0
    
    @IBAction func saveTapped(_ sender: UIButton) {
        showProgress(title: "")
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
        let selectedDate: String = dateFormatter.string(from: dateTimePicker.date)
        
        let entryPoint = EntryPoint(dateTime: selectedDate, temperature: temperatureSelected, humidity: humiditySelected)
        
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
                print("EntryPointSaved!")
                self?.saveSQL(entryPoint: entryPoint)
                self?.showSuccess(title: "")
                self?.dismiss(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButtons()
        configureGauge()
        configurePickers()
    }
    
    func configureButtons(){
        saveButton.makeRounded()
    }
    
    func configureGauge(){
        temperatureGauge.minValue = -10
        temperatureGauge.maxValue = 50
        temperatureGauge.numOfDivisions = 0
        temperatureGauge.unitOfMeasurement = "°C"
        temperatureGauge.unitOfMeasurementFont = .boldSystemFont(ofSize: 15)
        temperatureGauge.showMinMaxValue = false
        temperatureGauge.value = -10
        temperatureGauge.valueTextColor = UIColor(named: "chartYellow")!
        temperatureGauge.delegate = self
        
        humidityGauge.minValue = 0
        humidityGauge.maxValue = 100
        humidityGauge.numOfDivisions = 0
        humidityGauge.value = 0
        humidityGauge.unitOfMeasurement = "%"
        humidityGauge.unitOfMeasurementFont = .boldSystemFont(ofSize: 15)
        humidityGauge.showMinMaxValue = false
        humidityGauge.valueTextColor = UIColor(named: "chartBlue")!
        humidityGauge.delegate = self
    }
    
    func configurePickers(){
        for i in -10...50 {
            temperatureValues.append(i)
        }
        
        for i in 0...100 {
            humidityValues.append(i)
        }
    }
}

extension AddNewPointViewController: GaugeViewDelegate {
    func ringStokeColor(gaugeView: GaugeView, value: Double) -> UIColor {
        if gaugeView.maxValue == 100{
            return UIColor(named: "chartBlue")!
        }else{
            return UIColor(named: "chartYellow")!
        }
    }
}

extension AddNewPointViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return temperatureValues.count
        }else{
            return humidityValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return String(temperatureValues[row])
        }else{
            return String(humidityValues[row])
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            temperatureSelected = temperatureValues[row]
            temperatureGauge.value = Double(temperatureValues[row])
        }else{
            humiditySelected = humidityValues[row]
            humidityGauge.value = Double(humidityValues[row])
        }
    }
}
