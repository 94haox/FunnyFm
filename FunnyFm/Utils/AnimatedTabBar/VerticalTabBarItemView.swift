//
//  VerticalTabBarItemView.swift
//  FunnyFm
//
//  Created by Duke on 2020/2/6.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

protocol VerticalTabBarItemViewDelegate: AnyObject {
    func didTapped(on item: VerticalTabBarItemView)
}


class VerticalTabBarItemView: CommonUIView {
    private var contentView: UIView!
    private var imageView: UIImageView!
    private var labelAndDot : LabelAndDot!
    internal var position : Int = -1
    
    internal weak var delegate: VerticalTabBarItemViewDelegate?
    internal var associatedController: UIViewController?
    
    private var topConstraint: NSLayoutConstraint!
    internal var isSelected : Bool! {
        didSet {
            let newValue = isSelected ?? false
            let imageHeight = -imageView.bounds.height
            labelAndDot.isSelected = isSelected
            UIView.animate(withDuration: AnimatedTabBarAppearance.shared.animationDuration
                , delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.imageView.alpha = newValue ? 0 : 1
                self?.labelAndDot.alpha = newValue ? 1 : 0
                self?.topConstraint.constant = newValue ? imageHeight : 0
                self?.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    override func commonInit() {
        super.commonInit()
        contentView = UIView()
        imageView = UIImageView()
        labelAndDot = LabelAndDot()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configureContentView()
        configureImageView()
        configureLabelAndDot()
        if newSuperview != nil {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VerticalTabBarItemView.itemTapped(_:)))
            gestureRecognizer.numberOfTapsRequired = 1
            addGestureRecognizer(gestureRecognizer)
        } else {
            gestureRecognizers?.forEach(removeGestureRecognizer)
        }
        isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topConstraint.constant = (isSelected ?? false) ? -imageView.bounds.height : 0
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .clear
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.85)
        }
        
    }
    
    private func generateTopConstraint() {
        topConstraint = NSLayoutConstraint(item: imageView!,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: contentView,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0)
    }

    private func configureImageView() {
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.height.width.centerX.equalTo(contentView)
        }
        if topConstraint == nil {
            generateTopConstraint()
            addConstraint(topConstraint)
        }
    }
    
    private func configureLabelAndDot() {
        labelAndDot.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelAndDot)
        

        labelAndDot.snp.makeConstraints { (make) in
            make.height.width.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp_bottom)
        }
    }

    
    func setupView(model: AnimatedTabBarItem) {
        self.associatedController = model.controller
        labelAndDot.label.text = model.title
        imageView.image = model.icon
    }
    
    @objc private func itemTapped(_ sender: UITapGestureRecognizer) {
        delegate?.didTapped(on: self)
    }
}
