//
//  MasterViewController.swift
//  FunnyFm
//
//  Created by Duke on 2020/2/6.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit


class MasterViewController: UIViewController {
    open var tabBar : VerticalTabBar!
    open weak var delegate: VerticalTabBarDelegate?
    open var clickClosure: ((Int) ->Void)?
    var logoImage: UIImageView = UIImageView.init(image: UIImage.init(named: "logo_ipad"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CommonColor.white.color
        self.dw_addSubviews()
    }
        

}

extension MasterViewController : VerticalTabBarInternalDelegate {
    func selected(_ tabbar: VerticalTabBar, newItem: VerticalTabBarItemView?, oldItem: VerticalTabBarItemView?) {
        if self.clickClosure.isSome {
            self.clickClosure!(newItem!.position)
        }
    }
}

extension MasterViewController {
    
    private func dw_addSubviews() {
        
        self.view.addSubview(self.logoImage)
        self.logoImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40.auto())
            make.size.equalTo(CGSize.init(width: 50.auto(), height: 50.auto()))
        }
        
        self.addTabBar()
    }
    
    private func addTabBar() {
        let tabBar = VerticalTabBar()
        tabBar.internalDelegate = self
        tabBar.backgroundColor = AnimatedTabBarAppearance.shared.backgroundColor
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.delegate = delegate
        tabBar.clipsToBounds = true
        tabBar.backgroundColor = CommonColor.white.color
        view.addSubview(tabBar)
        
        tabBar.snp.makeConstraints { (make) in
            make.center.width.equalToSuperview()
            make.height.equalTo(400.auto())
        }
        self.tabBar = tabBar
    }
            
}


