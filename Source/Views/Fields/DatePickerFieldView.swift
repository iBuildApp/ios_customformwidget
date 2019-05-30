//
//  DatePickerFieldView.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 27/05/2019.
//

import UIKit
import FlexLayout
import PinLayout

class DatePickerFieldView: BaseFieldView {
    private let title = UILabel()
    private let datePicker = UIDatePicker()
    private let textFiled = PaddingTextField()
    private let formatter = DateFormatter()
    
    override func setup() {
        formatter.dateFormat = "MM/dd/yyyy"
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        if let value = field.value, let date = formatter.date(from: value) {
            datePicker.date = date
        }
        
        title.text = field.label
        title.textColor = colorScheme.color3.getColor() ?? .black
        
        textFiled.text = field.value
        textFiled.placeholder = "MM/DD/YYYY"
        textFiled.inputView = datePicker
        textFiled.layer.borderColor = UIColor.black.cgColor
        textFiled.layer.borderWidth = 1
        textFiled.layer.cornerRadius = 5
        textFiled.backgroundColor = .white
        
        flex.direction(.column).define { (flex) in
            flex.addItem(title).width(100%).height(30)
            flex.addItem(textFiled).width(100%).height(50)
        }
    }
    
    @objc func done() {
        textFiled.text = formatter.string(from: datePicker.date)
        self.textFiled.endEditing(true)
    }
    
    @objc func cancel() {
        self.textFiled.endEditing(true)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        textFiled.text = formatter.string(from: datePicker.date)
    }
    
    override func getContent() -> String {
        var content = ""
        if field.label != "" {
            content += "\(field.label): "
        }
        
        guard let dateValue = textFiled.text, !dateValue.isEmpty  else {
            content += "\(formatter.string(from: Date()))<br>"
            return content
        }
        
        content += "\(dateValue)<br>"
        return content
    }
}
