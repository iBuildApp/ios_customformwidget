//
//  PaddingTextField.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 29/05/2019.
//

import Foundation

class PaddingTextField: UITextField {
    
    var padding: CGFloat = 10 {
        didSet { setNeedsDisplay() }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
}
