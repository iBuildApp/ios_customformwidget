//
//  RadioGroup.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 27/05/2019.
//

import UIKit
import FlexLayout
import PinLayout

public class RadioGroup: UIControl {
    let rootFlexContainer = UIView()
    
    public convenience init(titles: [String]) {
        self.init(frame: .zero)
        self.titles = titles
        self.setup()
    }
    
    public var titles: [String] = []
    
    public var selectedIndex: Int = -1 {
        didSet {
            item(at: oldValue)?.checkbox.isChecked = false
            item(at: selectedIndex)?.checkbox.isChecked = true
        }
    }
    
    public var selectedColor: UIColor? {
        didSet {
            forEachItem {
                $0.checkbox.checkedBorderColor = selectedColor
                $0.checkbox.checkmarkColor = selectedColor
            }
        }
    }

    public var buttonSize: CGFloat = 20 {
        didSet {
            forEachItem {
                $0.checkbox.flex.height(buttonSize)
                $0.label.flex.height(buttonSize)
            }
        }
    }
    
    public var spacing: CGFloat = 8 {
        didSet {
            forEachItem { $0.flex.padding(spacing/2, 0, spacing/2, 0) }
        }
    }
    
    public var itemSpacing: CGFloat = 4 {
        didSet {
            forEachItem {
                $0.label.flex.marginLeft(itemSpacing)
            }
        }
    }
    
    public var titleColor: UIColor? {
        didSet {
            guard titleColor != oldValue else { return }
            forEachItem { $0.label.textColor = titleColor }
        }
    }
    
    public var titleAlignment: NSTextAlignment = .natural {
        didSet {
            forEachItem { $0.label.textAlignment = titleAlignment }
        }
    }
    
    public var titleFont: UIFont? {
        didSet {
            guard titleFont != oldValue else { return }
            let newFont = titleFont ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
            forEachItem { $0.label.font = newFont }
        }
    }
    
    // MARK: - Private
    private var items: [IBARadioGroupItem] = []
    
    private func setup() {
        items = titles.map({ IBARadioGroupItem(title: $0, group: self) })
        
        flex.direction(.column).define { (flex) in
            for item in items {
                flex.addItem(item)
            }
        }
    }
    
    private func item(at index: Int) -> IBARadioGroupItem? {
        guard index >= 0 && index < items.count else { return nil }
        return items[index]
    }
    
    private func forEachItem(_ perform: (IBARadioGroupItem) -> Void) {
        items.forEach(perform)
    }
    
    internal func selectIndex(item: IBARadioGroupItem) {
        guard let index = items.firstIndex(of: item) else { return }
        selectedIndex = index
        sendActions(for: [.valueChanged, .primaryActionTriggered])
    }
    
    var selectedItem: String {
        if selectedIndex > 0, selectedIndex < titles.count {
            return  titles[selectedIndex]
        } else {
            return ""
        }
    }
}

class IBARadioGroupItem: UIView {
    let checkbox = Checkbox()
    let label = UILabel()
    
    unowned var group: RadioGroup
    
    init(title: String, group: RadioGroup) {
        self.group = group
        super.init(frame: .zero)
        
        label.text = title
        if let titleFont = group.titleFont {
            label.font = titleFont
        }
        if let titleColor = group.titleColor {
            label.textColor = titleColor
        }
        checkbox.isUserInteractionEnabled = false
        checkbox.uncheckedBorderColor = .darkGray
        checkbox.borderStyle = .circle
        checkbox.checkmarkStyle = .circle
        checkbox.checkboxFillColor = .white
        
        if let selectedColor = group.selectedColor {
            checkbox.checkedBorderColor = selectedColor
            checkbox.checkmarkColor = selectedColor
        } else {
            checkbox.checkedBorderColor = .black
            checkbox.checkmarkColor = .black
        }
        
        flex.direction(.row).padding(group.spacing/2, 0, group.spacing/2, 0).define { (flex) in
            flex.addItem(checkbox).height(group.buttonSize).aspectRatio(1)
            flex.addItem(label).marginLeft(group.itemSpacing).height(group.buttonSize).grow(1)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelect)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didSelect() {
        group.selectIndex(item: self)
    }
}
