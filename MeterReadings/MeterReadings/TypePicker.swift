//
//  TypePicker.swift
//  MeterReadings
//
//  Created by Student on 03.07.21.
//

import Foundation
import MeterReadingsCore
import SwiftUI

class TypePicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    var pickerView: UIPickerView!
    var pickerData: [MeterType]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
}
