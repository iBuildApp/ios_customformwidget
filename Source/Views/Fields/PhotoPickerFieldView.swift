//
//  PhotoPickerFieldView.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 28/05/2019.
//

import UIKit
import FlexLayout
import PinLayout

import IBACore
import IBACoreUI

import Lightbox

class PhotoPickerFieldView: BaseFieldView {
    var prefix = ""
    let title = UILabel()
    let button = UIButton()
    
    var images = [UIImage]()
    
    var items = [ImageView]()
    
    let imagesContainer = UIView()
    
    override func setup() {
        title.text = field.label
        title.textColor = colorScheme.secondaryColor
        
        button.setTitle(field.value, for: .normal)
        button.backgroundColor = colorScheme.accentColor
        button.setTitleColor(colorScheme.backgroundColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18.0)
        
        flex.direction(.column).define { (flex) in
            flex.addItem(title).width(100%).height(30)
            
            flex.addItem(imagesContainer).direction(.row).alignContent(.start).wrap(.wrap).shrink(0).define({ (flex) in
                flex.addItem().height(0).width(0)
            })
            
            flex.addItem().direction(.row).define { (flex) in
                flex.addItem(button).padding(0, 10, 0, 10)
            }
        }
        
        button.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
    }
    
    @objc func showImagePicker() {
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        if let limit = field.limit, items.count >= limit {
            rootController.showAlertController(title: nil, message: "Reached the limit of photos", buttonTitle: Localization.Common.Text.ok)
        } else {
            let alert = UIAlertController(title: nil, message: "Select image", preferredStyle: .actionSheet)
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alert.addAction(UIAlertAction(title: "From camera", style: .default, handler: { _ in
                    let pickerController = UIImagePickerController()
                    pickerController.allowsEditing = false
                    pickerController.extendedLayoutIncludesOpaqueBars = true
                    pickerController.edgesForExtendedLayout = .all
                    pickerController.delegate = self
                    pickerController.sourceType = .camera
                    
                    rootController.present(pickerController, animated: true, completion: nil)
                }))
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                alert.addAction(UIAlertAction(title: "From album", style: .default, handler: { _ in
                    let pickerController = UIImagePickerController()
                    pickerController.allowsEditing = false
                    pickerController.extendedLayoutIncludesOpaqueBars = true
                    pickerController.edgesForExtendedLayout = .all
                    pickerController.delegate = self
                    pickerController.sourceType = .photoLibrary
                    
                    rootController.present(pickerController, animated: true, completion: nil)
                }))
            }
            
            alert.addAction(UIAlertAction(title: Localization.Common.Text.cancel, style: .cancel, handler: nil))
            
            rootController.present(alert, animated: true, completion: nil)
        }
    }
    
    func addImage(_ image: UIImage) {
        images.append(image)
        let view = ImageView(image: image, picker: self)
        items.append(view)
        imagesContainer.flex.addItem(view)
        imagesContainer.flex.layout(mode: .adjustHeight)
        rootFlexContainer.setNeedsLayout()
    }
    
    func remove(_ item: ImageView) {
        guard let index = items.firstIndex(of: item) else { return }
        images.remove(at: index)
        items.remove(at: index)
        item.isHidden = true
        item.flex.isIncludedInLayout(false)
        item.removeFromSuperview()
        imagesContainer.flex.layout(mode: .adjustHeight)
        rootFlexContainer.setNeedsLayout()
    }
    
    func showPreview(image: UIImage) {
        guard let index = images.firstIndex(of: image) else { return }
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController else { return }
        var lightboxImages = [LightboxImage]()
        
        for image in images {
            lightboxImages.append(LightboxImage(image: image))
        }
        
        let controller = LightboxController(images: lightboxImages, startIndex: index)
        controller.dynamicBackground = true
        rootController.present(controller, animated: true, completion: nil)
    }
    
    override func getContent() -> String {
        var content = ""
        if field.label != "" {
            content += "\(field.label):<br>"
        }
        
        for index in images.indices {
            content += "<img src=\"\(prefix)-\(field.label)-image-\(index).jpeg\" alt=\"\(prefix)-\(field.label)-image-\(index).jpeg\" /><br>"
        }
        
        content += "<br>"
        return content
    }
    
    override func getAttachments() -> [MailAttachment] {
        var attachments = [MailAttachment]()
        
        for (index, image) in images.enumerated() {
            let attachment = MailAttachment(image: image, name: "\(prefix)-\(field.label)-image-\(index)")
            attachments.append(attachment)
        }
        
        return attachments
    }
}

extension PhotoPickerFieldView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        self.addImage(image)
        
        picker.dismiss(animated: true, completion: nil)
    }
}

class ImageView: UIView {
    
    let image: UIImage
    
    let imageView = UIImageView()
    let button = UIButton()
    
    unowned var picker: PhotoPickerFieldView
    
    init(image: UIImage, picker: PhotoPickerFieldView) {
        self.image = image
        self.picker = picker
        super.init(frame: .zero)
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 10
        button.imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.setImage(getCoreUIImage(with: "loginScreenCloseButton"), for: .normal)
        
        flex.direction(.column).define { (flex) in
            flex.addItem(imageView).margin(10).height(50).aspectRatio(1)
            flex.addItem(button).width(20).aspectRatio(1).position(.absolute).top(2).right(2)
        }
        
        button.addTarget(self, action: #selector(remove), for: .touchUpInside)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPreview)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func remove() {
        picker.remove(self)
    }
    
    @objc
    private func showPreview() {
        picker.showPreview(image: image)
    }
}
