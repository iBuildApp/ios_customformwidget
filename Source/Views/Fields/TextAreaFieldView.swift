//
//  TextAreaFieldView.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 27/05/2019.
//

import UIKit
import IBACoreUI
import FlexLayout
import PinLayout

class TextAreaFieldView: BaseFieldView {
    
    let title = UILabel()
    let textView = GrowingTextView()
    
    var minHeight: CGFloat = 120
    
    override func setup() {
        title.text = field.label
        title.textColor = colorScheme.color3.getColor() ?? .black
        
        textView.placeholder = field.value ?? ""
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.backgroundColor = .white
        
        flex.direction(.column).define { (flex) in
            flex.addItem(title).height(30)
            flex.addItem(textView).height(minHeight)
        }
    }
    
    func updateTextViewHeight(_ height: CGFloat) {
        textView.flex.markDirty()
        textView.flex.height(height > minHeight ? height : minHeight)
        flex.layout(mode: .adjustHeight)
        rootFlexContainer.setNeedsLayout()
    }
    
    override func getContent() -> String {
        var content = ""
        if field.label != "" {
            content += "\(field.label): "
        }
        
        guard let value = textView.text else {
            return content
        }
        
        content += "\(value)<br>"
        return content
    }
}

extension TextAreaFieldView: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        self.updateTextViewHeight(height)
    }
}
