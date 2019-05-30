//
//  CustomFormViewController.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 23/05/2019.
//

import UIKit
import IBACore
import IBACoreUI
import MessageUI

class CustomFormViewController: BaseViewController {
    // MARK: - Private properties
    /// Widget type indentifier
    private var type: String?
    
    /// Widger config data
    private var data: DataModel?
    
    // MARK: - Controller life cycle methods
    convenience init(type: String?, data: DataModel?) {
        self.init()
        self.type = type
        self.data = data
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate var mainView: CustomFormView {
        return self.view as! CustomFormView
    }
    
    override func loadView() {
        if let form = data?.form, let colorScheme = data?.colorScheme {
            self.view = CustomFormView(form: form, colorScheme: colorScheme)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.sendContent = { content, attachments in
            let address = self.data?.form.email?.address ?? ""
            let subject = self.data?.form.email?.subject ?? ""
            
            AppCoreServices.showMailComposer(with: [address], subject: subject, body: content, attachments: attachments, for: self)
        }
    }
}

extension CustomFormViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            controller.dismiss(animated: true, completion: nil)
        case .failed:
            controller.dismiss(animated: true) {
                self.showAlertController(title: Localization.Email.Message.Error.title, message: Localization.Email.Message.Error.body, buttonTitle: Localization.Common.Text.ok, action: nil)
            }
            
        case .sent:
            controller.dismiss(animated: true) {
                self.showAlertController(title: nil, message: Localization.Email.Message.success, buttonTitle: Localization.Common.Text.ok, action: {
                    self.navigationController?.popViewController(animated: false)
                })
            }
            
        default:
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
