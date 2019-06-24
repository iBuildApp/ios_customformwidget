//
//  CheckboxFieldView.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 27/05/2019.
//

import UIKit
import IBACoreUI
import FlexLayout
import PinLayout

class CheckboxFieldView: BaseFieldView {
    let checkbox = Checkbox()
    let label = UILabel()
    
    override func setup() {
        checkbox.isUserInteractionEnabled = false
        checkbox.checkedBorderColor = .black
        checkbox.uncheckedBorderColor = .darkGray
        checkbox.borderStyle = .square
        checkbox.checkmarkColor = .black
        checkbox.checkmarkStyle = .tick
        checkbox.backgroundColor = .white
        checkbox.isChecked = field.value == "checked"
        
        label.text = field.label
        label.textColor = colorScheme.secondaryColor
        
        flex.direction(.row).define { (flex) in
            flex.addItem(checkbox).height(30).aspectRatio(1)
            flex.addItem(label).marginLeft(10).height(30)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelect)))
    }
    
    @objc func didSelect() {
        checkbox.isChecked = !checkbox.isChecked
    }
    
    override func getContent() -> String {
        var content = ""
        if field.label != "" {
            content += "\(field.label): "
        }
        content +=  "\(checkbox.isChecked ? "YES" : "NO")<br>"
        return content
    }
}
