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
    var logoutBtn: UIButton!
    var logoImage: UIImageView = UIImageView.init(image: UIImage.init(named: "logo_ipad"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.dw_addSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAccountStatus), name: Notification.loginSuccess, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAccountStatus()
    }
    
    @objc func toLogoutAction(){
        
        if !UserCenter.shared.isLogin {
            if #available(iOS 13.0, *) {
                let loginNavi = UINavigationController.init(rootViewController: AppleLoginTypeViewController.init())
                loginNavi.navigationBar.isHidden = true
                self.splitViewController?.present(loginNavi, animated: true, completion: nil)
                return
            }
            
            let loginNavi = UINavigationController.init(rootViewController: LoginTypeViewController.init())
            loginNavi.navigationBar.isHidden = true
            self.splitViewController?.present(loginNavi, animated: true, completion: nil)
            return
        }
        
        UserCenter.shared.isLogin = false
        HorizonHUD.showSuccess("退出成功".localized)
        self.updateAccountStatus()
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
        self.addLoginButton()
    }
    
    private func addTabBar() {
            let tabBar = VerticalTabBar()
            tabBar.internalDelegate = self
            tabBar.backgroundColor = AnimatedTabBarAppearance.shared.backgroundColor
            tabBar.translatesAutoresizingMaskIntoConstraints = false
            tabBar.delegate = delegate
            tabBar.clipsToBounds = true
            view.addSubview(tabBar)
            
            tabBar.snp.makeConstraints { (make) in
                make.center.width.equalToSuperview()
                make.height.equalTo(400.auto())
            }
            self.tabBar = tabBar
        }
        
        @objc func updateAccountStatus(){
            if UserCenter.shared.isLogin {
                logoutBtn.setTitle("退出登录".localized, for: .normal)
            }else{
                logoutBtn.setTitle("登录".localized, for: .normal)
            }
        }
        
        
        private func addLoginButton(){
            self.logoutBtn = UIButton.init(type: .custom)
            logoutBtn.setTitleColor(.white, for: .normal)
            logoutBtn.backgroundColor = CommonColor.mainRed.color
            logoutBtn.cornerRadius = 5.0
            logoutBtn.titleLabel?.font = p_bfont(12);
            logoutBtn.addTarget(self, action: #selector(toLogoutAction), for: .touchUpInside)
            self.view.addSubview(self.logoutBtn)
            self.logoutBtn.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalTo(30.auto())
                make.top.equalTo(self.logoImage.snp_bottom).offset(16.auto())
            }

        }
    
}


