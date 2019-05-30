//
//  RadioGroupFieldView.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 27/05/2019.
//

import UIKit
import FlexLayout
import PinLayout

class RadioGroupFieldView: BaseFieldView {
    var radioGroup: RadioGroup!
    
    override func setup() {
        guard let groupField = field as? RadioGroupModel else {
            return
        }
        let titles = groupField.fields.map { $0.label }
        let selectedIdx = groupField.fields.firstIndex { $0.value == "checked" }
        radioGroup = RadioGroup(titles: titles)
        radioGroup.selectedIndex = selectedIdx ?? 0
        radioGroup.titleColor = colorScheme.color3.getColor() ?? .black
        radioGroup.buttonSize = 30
        radioGroup.itemSpacing = 10

        flex.direction(.column).define { (flex) in
            flex.addItem(radioGroup)
        }
    }
    
    override func getContent() -> String {
        return "\(radioGroup.selectedItem)<br>"
    }
}
