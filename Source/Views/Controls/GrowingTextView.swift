//
//  GrowingTextView.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 29/05/2019.
//

import UIKit

public protocol GrowingTextViewDelegate: UITextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat)
}

public class GrowingTextView: UITextView {
    override open var text: String! {
        didSet { setNeedsDisplay() }
    }
    
    // Maximum length of text. 0 means no limit.
    public var maxLength: Int = 0
    
    // Trim white space and newline characters when end editing. Default is true
    public var trimWhiteSpaceWhenEndEditing: Bool = true
    
    // Customization
    public var minHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }
    public var maxHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }
    public var placeholder: String? {
        didSet { setNeedsDisplay() }
    }
    public var placeholderColor: UIColor = UIColor(white: 0.8, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }
    public var attributedPlaceholder: NSAttributedString? {
        didSet { setNeedsDisplay() }
    }
    
    // Initialize
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentMode = .redraw
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }
    
    // Calculate and adjust textview's height
    private var oldText: String = ""
    private var oldSize: CGSize = .zero
    private var oldHeight: CGFloat = 0
    
    private func forceLayoutSubviews() {
        oldSize = .zero
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private var shouldScrollAfterHeightChanged = false
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if text == oldText && bounds.size == oldSize { return }
        oldText = text
        oldSize = bounds.size
        
        let size = sizeThatFits(CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height
        
        // Constrain minimum height
        height = minHeight > 0 ? max(height, minHeight) : height
        
        // Constrain maximum height
        height = maxHeight > 0 ? min(height, maxHeight) : height

        // Update height if needed
        if height != oldHeight {
            shouldScrollAfterHeightChanged = true
            oldHeight = height
            if let delegate = delegate as? GrowingTextViewDelegate {
                delegate.textViewDidChangeHeight(self, height: height)
            }
        } else if shouldScrollAfterHeightChanged {
            shouldScrollAfterHeightChanged = false
            scrollToCorrectPosition()
        }
    }
    
    private func scrollToCorrectPosition() {
        if self.isFirstResponder {
            self.scrollRangeToVisible(NSRange(location: -1, length: 0)) // Scroll to bottom
        } else {
            self.scrollRangeToVisible(NSRange(location: 0, length: 0)) // Scroll to top
        }
    }
    
    // Show placeholder if needed
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if text.isEmpty {
            let xValue = textContainerInset.left + textContainer.lineFragmentPadding
            let yValue = textContainerInset.top
            let width = rect.size.width - xValue - textContainerInset.right
            let height = rect.size.height - yValue - textContainerInset.bottom
            let placeholderRect = CGRect(x: xValue, y: yValue, width: width, height: height)
            
            if let attributedPlaceholder = attributedPlaceholder {
                // Prefer to use attributedPlaceholder
                attributedPlaceholder.draw(in: placeholderRect)
            } else if let placeholder = placeholder {
                // Otherwise user placeholder and inherit `text` attributes
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = textAlignment
                var attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: placeholderColor,
                    .paragraphStyle: paragraphStyle
                ]
                if let font = font {
                    attributes[.font] = font
                }
                
                placeholder.draw(in: placeholderRect, withAttributes: attributes)
            }
        }
    }
    
    // Trim white space and new line characters when end editing.
    @objc func textDidEndEditing(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            if trimWhiteSpaceWhenEndEditing {
                text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                setNeedsDisplay()
            }
            scrollToCorrectPosition()
        }
    }
    
    // Limit the length of text
    @objc func textDidChange(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            if maxLength > 0 && text.count > maxLength {
                let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                text = String(text[..<endIndex])
                undoManager?.removeAllActions()
            }
            setNeedsDisplay()
        }
    }
}
