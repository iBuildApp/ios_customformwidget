//
//  CustomFormView.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 24/05/2019.
//

import UIKit
import FlexLayout
import PinLayout
import IBACore
import PKHUD

public class CustomFormView: UIView {
    private let contentView = UIScrollView()
    private let rootFlexContainer = UIView()
    
    public let sendButton = UIButton(type: .custom)
    public var sections = [FormSectionView]()
    
    var sendContent: ((String, [MailAttachment])->Void)?
    
    private let form: FormModel
    private let colorScheme: ColorSchemeModel
    
    init(form: FormModel, colorScheme: ColorSchemeModel) {
        self.form = form
        self.colorScheme = colorScheme
        super.init(frame: .zero)
        
        backgroundColor = colorScheme.backgroundColor
        
        sendButton.setTitle(form.email?.button?.label ?? "SEND", for: .normal)
        sendButton.backgroundColor = colorScheme.color5.getColor() ?? .darkGray
        sendButton.setTitleColor(colorScheme.backgroundColor, for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 22.0)

        rootFlexContainer.flex.define { (flex) in
            
            for section in form.groups {
                let sectionView = FormSectionView(section: section, colorScheme: colorScheme, root: self)
                sections.append(sectionView)
                flex.addItem(sectionView)
            }
            
            flex.addItem(sendButton).margin(20).height(50)
        }

        contentView.addSubview(rootFlexContainer)
        
        addSubview(contentView)
        
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        // 1) Layout the contentView & rootFlexContainer using PinLayout
        contentView.pin.all(pin.safeArea)
        rootFlexContainer.pin.top().left().right()

        // 2) Let the flexbox container layout itself and adjust the height
        rootFlexContainer.flex.layout(mode: .adjustHeight)

        // 3) Adjust the scrollview contentSize
        contentView.contentSize = rootFlexContainer.frame.size
    }
    
    @objc func send() {
        HUD.show(.progress)
        var content = ""
        
        content += "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><style type=\"text/css\">BODY {font-family: Arial, sans-serif;font-size:12px;}</style></head><body>"
        
        for section in sections {
            content += section.getContent()
        }
        content += "</body></html>"
        
        var attachments = [MailAttachment]()
        
        for section in sections {
            attachments += section.getAttachments()
        }
        HUD.hide()
        sendContent?(content, attachments)
    }
}
