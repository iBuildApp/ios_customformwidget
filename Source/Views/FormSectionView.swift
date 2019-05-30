//
//  FormSectionView.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 24/05/2019.
//

import UIKit
import FlexLayout
import PinLayout

import IBACore

public class FormSectionView: UIView {
    private let rootFlexContainer = UIView()
    
    private let section: SectionModel
    private let colorScheme: ColorSchemeModel
    
    public let title = UILabel()
    
    internal var fields = [BaseFieldView]()
    
    init(section: SectionModel, colorScheme: ColorSchemeModel, root: UIView) {
        self.section = section
        self.colorScheme = colorScheme
        super.init(frame: .zero)
        
        title.text = section.title
        title.textColor = colorScheme.color5.getColor() ?? .black
        title.font = .systemFont(ofSize: 19.0)
        
        rootFlexContainer.flex.direction(.column).define { (flex) in
            flex.addItem().direction(.column).padding(12).define { (flex) in
                flex.addItem(title).margin(8)
                
                for field in section.groupedFields {
                    let item: BaseFieldView
                    
                    switch field.type {
                    case .entryfield:
                        item = TextFieldView(field: field, colorScheme: colorScheme, root: root)
                        
                    case .textarea:
                        item = TextAreaFieldView(field: field, colorScheme: colorScheme, root: root)
                        
                    case .datepicker:
                        item = DatePickerFieldView(field: field, colorScheme: colorScheme, root: root)
                        
                    case .dropdown:
                        item = PickerFieldView(field: field, colorScheme: colorScheme, root: root)
                        
                    case .radiogroup:
                        item = RadioGroupFieldView(field: field, colorScheme: colorScheme, root: root)
                        
                    case .checkbox:
                        item = CheckboxFieldView(field: field, colorScheme: colorScheme, root: root)
                        
                    case .photopicker:
                        let photoPicker = PhotoPickerFieldView(field: field, colorScheme: colorScheme, root: root)
                        photoPicker.prefix = section.title
                        item = photoPicker
                        
                    default:
                        item = BaseFieldView(field: field, colorScheme: colorScheme, root: root)
                    }
                    
                    fields.append(item)
                    flex.addItem(item).margin(8)
                }
            }
            
            flex.addItem().height(1).backgroundColor(.lightGray)
        }
        
        addSubview(rootFlexContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getContent() -> String {
        var content = "<style>a { text-decoration: none; color:#3399FF;}</style><span style='font-family:Helvetica; font-size:16px; font-weight:bold;'><p align=\"center\">\(section.title)</p></span>"
        
        for field in fields {
            content += field.getContent()
        }
        
        return content
    }
    
    func getAttachments() -> [MailAttachment] {
        var attachments = [MailAttachment]()
        
        for field in fields {
            attachments += field.getAttachments()
        }
        
        return attachments
    }
}
