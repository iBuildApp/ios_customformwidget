//
//  BaseFieldView.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 27/05/2019.
//

import UIKit
import FlexLayout
import PinLayout
import IBACore

class BaseFieldView: UIView {
    internal let rootFlexContainer: UIView
    internal let field: BaseField
    
    internal let colorScheme: ColorSchemeModel
    
    init(field: BaseField, colorScheme: ColorSchemeModel, root: UIView) {
        self.field = field
        self.colorScheme = colorScheme
        self.rootFlexContainer = root
        super.init(frame: .zero)
        
        self.setup()
    }
    
    open func setup() { }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func getContent() -> String {
        return ""
    }
    
    open func getAttachments() -> [MailAttachment] {
        return []
    }
}
