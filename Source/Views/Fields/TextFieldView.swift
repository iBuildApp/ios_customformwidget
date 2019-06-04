//
//  TextFieldView.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 27/05/2019.
//

import UIKit
import IBACoreUI
import FlexLayout
import PinLayout

class TextFieldView: BaseFieldView {
    private let title = UILabel()
    private let textFiled = PaddingTextField()
    
    override func setup() {
        title.text = field.label
        title.textColor = colorScheme.color3.getColor() ?? .black
        
        textFiled.placeholder = field.value
        textFiled.keyboardType = field.format == .number ? UIKeyboardType.decimalPad : UIKeyboardType.default
        textFiled.layer.borderColor = UIColor.black.cgColor
        textFiled.layer.borderWidth = 1
        textFiled.layer.cornerRadius = 5
        textFiled.backgroundColor = .white
        
        flex.direction(.column).define { (flex) in
            flex.addItem(title).width(100%).height(30)
            flex.addItem(textFiled).width(100%).height(50)
        }
    }
    
    override func getContent() -> String {
        var content = ""
        if field.label != "" {
            content += "\(field.label): "
        }
        
        guard let value = textFiled.text else {
            return content
        }
        
        content += "\(value)<br>"
        return content
    }
}
