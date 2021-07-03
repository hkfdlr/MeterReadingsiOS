//
//  MeterTypePicker.swift
//  MeterReadings
//
//  Created by Student on 03.07.21.
//

import Foundation
import SwiftUI
import MeterReadingsCore

class MeterTypePicker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let picker = UIPickerView()
        picker.frame = self.view.frame
        
        self.view.addSubview(picker)
        picker.delegate = self
        picker.dataSource = self
    }
    
    var data = MeterType.allCases
}
