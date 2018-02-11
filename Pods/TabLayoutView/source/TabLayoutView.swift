//
//  TabLayoutView.swift
//
//
//  Created by Dario Trisciuoglio on 02/09/17.
//  Copyright © 2017 Dario Trisciuoglio. All rights reserved.
//

import UIKit

/// The TabLayoutViewDelegate protocol defines methods that a delegate of a TabLayoutView object can optionally implement to intervene when user selected a tab.
@objc public protocol TabLayoutViewDelegate: UIScrollViewDelegate {
    
    /// Tells the delegate when the user is selected a tab.
    ///
    /// - parameter tabLayoutView:       The tabLayoutView object in which the selection occurred.
    /// - parameter index:               The index of the selected tab.
    ///
    @objc optional func tabLayoutView(_ tabLayoutView: TabLayoutView, didSelectTabAt index: Int)
}

public enum TabLayoutViewType : Int {
    case normal = 0
    case center
    case fill
}

public enum TabLayoutViewIndicatorPosition : Int {
    case bottom = 0
    case top
}

///A `TabLayoutView` object is a horizontal control made of multiple tabs, each tab functioning as a discrete button.
@IBDesignable
open class TabLayoutView: UIScrollView {
    
    // MARK: - Properties

	/// Set indicator color
    @IBInspectable open var indicatorColor: UIColor = .black {
        didSet {
            self.tabLayoutControl.indicator.backgroundColor = self.indicatorColor
        }
    }
    
    /// Set indicator height
    /// The default value is 3.
    @IBInspectable open var indicatorHeight: CGFloat = 3 {
        didSet {
            self.tabLayoutControl.indicatorHeight = self.indicatorHeight
        }
    }
    
    /// Set indicator position
    /// The default value is bottom.
    open var indicatorPosition: TabLayoutViewIndicatorPosition = .bottom {
        didSet {
            self.tabLayoutControl.indicatorPosition = self.indicatorPosition
        }
    }
    
    /// Set type layout for tabs
    /// The default value is fill.
    open var type: TabLayoutViewType = .normal
    
    /// Set tab font color for normal state
    @IBInspectable open var fontColor: UIColor = .black {
        didSet {
            self.didSetFont()
        }
    }

	/// Set tab font color for selected state
    @IBInspectable open var fontSelectedColor: UIColor = .black {
        didSet {
            self.didSetFontSelected()
        }
    }
	
    /// Set tab font for normal state
    open var font: UIFont = .systemFont(ofSize: 15) {
        didSet {
            self.didSetFont()
        }
    }
    
    /// Set tab font for selected state
    open var fontSelected: UIFont = .boldSystemFont(ofSize: 15) {
        didSet {
            self.didSetFontSelected()
        }
    }
    
    /// An array of string for tab titles.
    open var items: [String] = [] {
        didSet {
			self.tabLayoutControl.removeAllSegments()
            for (index, item) in self.items.enumerated() {
                self.tabLayoutControl.insertSegment(withTitle: item, at: index, animated: false)
            }
            self.selectedSegmentIndex = 0
            self.tabLayoutControl.addTarget(self, action: #selector(self.segmentedValueChanged), for: .valueChanged)
			self.contentSize = CGSize(width: self.contentWidth, height: self.bounds.height)
			self.addConstraint()
        }
    }
	
	/// The index number identifying the selected tab (that is, the last tab touched).
	open var selectedSegmentIndex: Int {
		get { return self.tabLayoutControl.selectedSegmentIndex }
		set { self.tabLayoutControl.selectedSegmentIndex = newValue }
	}
    
    // MARK: - Initialization
    
    /// Initializes and returns a tab layout view with tabs having the given titles
    public convenience init(items: [String]) {
        self.init()
        self.items = items
		self.commonInit()
    }
    
    /// Initializes and returns a tab layout view
    public init() {
        super.init(frame: .zero)
        self.commonInit()
    }
    
    /// Initializes and returns a tab layout view
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    // MARK: - UIView
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.contentSize = CGSize(width: self.contentWidth, height: self.bounds.height)
        self.addConstraint()
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft, self.responds(to: #selector(getter: self.semanticContentAttribute)) {
            semanticContentAttribute = .forceRightToLeft
        }
        self.didSetFont()
        self.didSetFontSelected()
        self.tabLayoutControl.indicator.backgroundColor = self.indicatorColor
    }
    
    private func addConstraint() {
        // if self.contentWidth == 0 { return }
        self.tabLayoutControl.removeFromSuperview()
        switch self.type {
        case .normal, .center:
            self.addTabLayoutControl(self.type)
        case .fill:
            if self.contentWidth > self.bounds.size.width {
                self.addTabLayoutControl(self.type)
            } else {
                self.tabLayoutControl.frame = self.bounds
                self.addSubview(self.tabLayoutControl)
                let width = self.frame.size.width / CGFloat(self.items.count)
                for index in 0..<self.items.count {
                    self.tabLayoutControl.setWidth(width, forSegmentAt: index)
                }
            }
        }
    }
    
    @objc private func segmentedValueChanged(_ sender: TabLayoutControl) {
        self.scrollRectToVisible(sender.getRectForSegment(at: sender.selectedSegmentIndex), animated: true)
        (self.delegate as? TabLayoutViewDelegate)?.tabLayoutView?(self, didSelectTabAt: sender.selectedSegmentIndex)
    }
    
    private func didSetFontSelected() {
        let selectedTitleTextAttributes: [String : Any] = [NSAttributedStringKey.foregroundColor.rawValue: self.fontSelectedColor, NSAttributedStringKey.font.rawValue: self.fontSelected]
        self.tabLayoutControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
    }
    
    private func didSetFont() {
        let titleTextAttributes: [String : Any] = [NSAttributedStringKey.foregroundColor.rawValue: self.fontColor, NSAttributedStringKey.font.rawValue: self.font]
        self.tabLayoutControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
    }
    
    private var tabLayoutControl = TabLayoutControl()
    
    private var contentWidth: CGFloat {
        var frame = self.tabLayoutControl.frame
        frame.size.height = self.frame.height
        self.tabLayoutControl.frame = frame
        var contentWidth: CGFloat = self.tabLayoutControl.getWidth()
        if contentWidth < frame.width {
            contentWidth = frame.width
        }
        return contentWidth
    }
	
	private func addTabLayoutControl(_ type: TabLayoutViewType) {
		self.tabLayoutControl.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.tabLayoutControl)
		let heightConstraint = NSLayoutConstraint(item: self.tabLayoutControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.frame.size.height)
		if type == .center {
			let xConstraint = NSLayoutConstraint(item: self.tabLayoutControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
			let yConstraint = NSLayoutConstraint(item: self.tabLayoutControl, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
			NSLayoutConstraint.activate([heightConstraint, xConstraint, yConstraint])
		} else if type == .normal {
			let topConstraint = NSLayoutConstraint(item: self.tabLayoutControl, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
			let leftConstraint = NSLayoutConstraint(item: self.tabLayoutControl, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
			NSLayoutConstraint.activate([heightConstraint, leftConstraint, topConstraint])
		} else {
			let topConstraint = NSLayoutConstraint(item: self.tabLayoutControl, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
			let leftConstraint = NSLayoutConstraint(item: self.tabLayoutControl, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
			let rightConstraint = NSLayoutConstraint(item: self.tabLayoutControl, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
			let bottomConstraint = NSLayoutConstraint(item: self.tabLayoutControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
			NSLayoutConstraint.activate([bottomConstraint, rightConstraint, leftConstraint, topConstraint])
		}
	}
}

fileprivate class TabLayoutControl: UISegmentedControl {
    
    // MARK: - Properties
    
    var indicatorHeight: CGFloat = 3
    var indicatorMinX: CGFloat = 0
    var indicatorWidth: CGFloat = 0
    var indicatorPosition: TabLayoutViewIndicatorPosition = .bottom
    
    var indicator: UIImageView = UIImageView()
    var segments: [UIView]! {
        return self.value(forKey: "_segments") as! [UIView]
    }
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(items: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.clipsToBounds = true
        self.apportionsSegmentWidthsByContent = true
        self.addSubview(self.indicator)
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft && responds(to: #selector(setter: self.semanticContentAttribute)) {
            semanticContentAttribute = .forceRightToLeft
            self.indicator.semanticContentAttribute = .forceRightToLeft
        }
        self.tintColor = .clear
        self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        self.addTarget(self, action: #selector(self.segmentedValueChanged), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setSelectedIndicator(withAnimation: false)
    }
    
    // MARK: - TabLayoutControl
    
    func getRectForSegment(at index: Int) -> CGRect {
        if index < 0 { return .zero }
        return self.segments[index].frame
    }
    
    func getMinXForSegment(at index: Int) -> CGFloat {
        if index < 0 { return 0 }
        return self.segments[index].frame.minX
    }
    
    func getWidthForSegment(at index: Int) -> CGFloat {
        if index < 0 { return 0 }
        return self.segments[index].frame.width
    }
    
    func getWidth() -> CGFloat {
        var width: CGFloat = 0
        for segment in self.segments {
            width += segment.frame.width
        }
        return width
    }
    
    @objc func segmentedValueChanged(_ sender: Any?) {
        self.setSelectedIndicator(withAnimation: true)
    }
    
    func setSelectedIndicator(withAnimation animation: Bool) {
        self.indicatorMinX = getMinXForSegment(at: self.selectedSegmentIndex)
        self.indicatorWidth = getWidthForSegment(at: self.selectedSegmentIndex)
        self.updateIndicator(withAnimation: true)
    }
    
    func updateIndicator(withAnimation animation: Bool) {
        var indicatorY: CGFloat = 0
        if self.indicatorPosition == .bottom {
            indicatorY = self.frame.height - self.indicatorHeight
        }
        UIView.animate(withDuration: animation ? 0.25 : 0, animations: {() -> Void in
            var frame: CGRect = self.indicator.frame
            frame.origin.x = self.indicatorMinX
            frame.origin.y = indicatorY
            frame.size.width = self.indicatorWidth
            frame.size.height = self.indicatorHeight
            self.indicator.frame = frame
        })
    }
}
