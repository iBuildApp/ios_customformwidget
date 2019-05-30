//
//  PickerFieldView.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 27/05/2019.
//

import UIKit
import FlexLayout
import PinLayout

class PickerFieldView: BaseFieldView, UIPickerViewDelegate, UIPickerViewDataSource {
    private let title = UILabel()
    private let pickerView = UIPickerView()
    private let textFiled = PaddingTextField()
    private let formatter = DateFormatter()
    
    override func setup() {
        pickerView.delegate = self
        
        title.text = field.label
        title.textColor = colorScheme.color3.getColor() ?? .black
        
        textFiled.text = field.values?.first
        textFiled.layer.borderColor = UIColor.black.cgColor
        textFiled.layer.borderWidth = 1
        textFiled.layer.cornerRadius = 5
        textFiled.backgroundColor = .white
        textFiled.inputView = pickerView
        
        flex.direction(.column).define { (flex) in
            flex.addItem(title).width(100%).height(30)
            flex.addItem(textFiled).width(100%).height(50)
        }
    }
    
    @objc func done() {
        self.textFiled.endEditing(true)
    }
    
    @objc func cancel() {
        self.textFiled.endEditing(true)
    }
    
    // MARK: UIPickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return field.values?.count ?? 0
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return field.values?[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFiled.text = field.values?[row]
    }
    
    override func getContent() -> String {
        var content = ""
        if field.label != "" {
            content += "\(field.label): "
        }
        
        guard let value = textFiled.text else {
            content += "<br>"
            return content
        }
        
        content += "\(value)<br>"
        return content
    }
}
