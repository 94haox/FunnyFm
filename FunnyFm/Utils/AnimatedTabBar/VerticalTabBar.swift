//
//  VerticalTabBar.swift
//  FunnyFm
//
//  Created by Duke on 2020/2/6.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

public protocol VerticalTabBarDelegate : AnyObject {
    var vNumberOfItems : Int { get }
    func vTabBar(_ tabBar: VerticalTabBar, itemFor index: Int) -> AnimatedTabBarItem
    func vInitialIndex(_ tabBar: VerticalTabBar) -> Int?
}

protocol VerticalTabBarInternalDelegate : AnyObject {
    func selected(_ tabbar: VerticalTabBar, newItem: VerticalTabBarItemView?, oldItem: VerticalTabBarItemView?)
}


open class VerticalTabBar: CommonUIView {
    var itemViews = [VerticalTabBarItemView]()
    var contentView : UIView!
    var leftView: UIView!
    var stackView: UIStackView!
    open weak var delegate: VerticalTabBarDelegate?
    weak var internalDelegate : VerticalTabBarInternalDelegate?
    
    internal weak var containerView : UIView?
    private(set) var selected: VerticalTabBarItemView? {
        didSet {
            internalDelegate?.selected(self,
                                       newItem: selected,
                                       oldItem: oldValue)
        }
    }
    
    override func commonInit() {
        super.commonInit()
        contentView = UIView()
        stackView = UIStackView()
        leftView = UIView()
        self.backgroundColor = CommonColor.white.color
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configureContentView()
        if delegate?.vNumberOfItems ?? 0 > 0 {
            configureStackView()
            configureLeftView()
            fillStackView()
        }
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        selectItem(at: selected?.position ?? delegate?.vInitialIndex(self) ?? 0)
    }
    
    func configureContentView() {
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.layer.masksToBounds = true
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
            make.top.height.equalToSuperview()
        }
    }
    
    func configureStackView() {
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20.auto()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(50.auto())
            make.left.width.equalTo(contentView)
        }
    }
    
    func configureLeftView() {
        leftView.backgroundColor = R.color.mainRed()
        addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(35.auto())
            make.width.equalTo(6.auto())
            make.centerY.equalToSuperview()
        }
    }
    
    private func fillStackView() {
        for i in 0 ..< ( delegate?.vNumberOfItems ?? 0 ) {
            if let item = delegate?.vTabBar(self, itemFor: i) {
                // Add View to the stack
                let view = VerticalTabBarItemView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
                itemViews.append(view)
                view.delegate = self
                stackView.addArrangedSubview(view)
                view.setupView(model: item)
                view.position = i
                view.isSelected = false
            }
        }
    }

    private func selectItem(at position: Int) {
        if position < stackView.arrangedSubviews.count && position >= 0 {
            selected?.isSelected = false
            selected = stackView.arrangedSubviews[position] as? VerticalTabBarItemView
            selected?.isSelected = true
            leftView.snp.remakeConstraints { (make) in
                make.left.equalToSuperview()
                make.height.equalTo(35.auto())
                make.width.equalTo(6.auto())
                make.centerY.equalTo(selected!)
            }
        }
    }
}

extension VerticalTabBar : VerticalTabBarItemViewDelegate {
    
    func didTapped(on item: VerticalTabBarItemView) {
        if item.isSelected { // move to root
            
        } else { // replace view
            selectItem(at: item.position)
        }
    }
}

