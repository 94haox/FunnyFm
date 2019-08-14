//
//  RegisterViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/4.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController, ViewModelDelegate {

    @IBOutlet var tipLB: UIView!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var nextImageVIew: UIImageView!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    var isLoading = false
    
    var viewModel: LoginViewModel = LoginViewModel()
    
    var mailTF : FMTextField!
    
    var passTF : FMTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.dw_addSubviews()
        self.loadingView.isHidden = true
        self.viewModel.delegate = self
        self.dw_addTouchEndEdit()
    }

    @IBAction func registerAction(_ sender: Any) {
        self.endEidted()
        
        if self.isLoading {
            return
        }
        
        if let mail = self.mailTF.text, mail.count < 1 {
            SwiftNotice.showText("请输入邮箱地址".localized)
            return
        }else if let mail = self.mailTF.text, !VaildManager.isMail(mail) {
            SwiftNotice.showText("请输入正确邮箱地址".localized)
            return
        }
        
        if let pwd = self.passTF.text, pwd.count < 1 {
            SwiftNotice.showText("请输入密码".localized)
            return
        }else if let pwd = self.passTF.text, pwd.count != 6{
            SwiftNotice.showText("请输入正确密码（六位）".localized)
            return
        }
        self.showLoading()
        self.viewModel.register(mail: self.mailTF.text!, and: self.passTF.text!)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController()
    }
	
    func showLoading() {
        self.isLoading = true
        self.loadingView.isHidden = false
        self.nextImageVIew.isHidden = true
        self.loadingView.startAnimating()
    }
    
    func hideLoading(){
        self.isLoading = false
        self.loadingView.isHidden = true
        self.nextImageVIew.isHidden = false
        self.loadingView.stopAnimating()
    }

}


extension RegisterViewController {
    
    func viewModelDidGetDataSuccess() {
        self.hideLoading()
        HorizonHUD.showSuccess("登录成功".localized)
		NotificationCenter.default.post(name: NSNotification.Name.init(kParserNotification), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
//		let profileVC = profil
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
        self.hideLoading()
        SwiftNotice.showText(msg!)
    }
    
    
}

extension RegisterViewController {
    
    func dw_addSubviews() {
        
        self.mailTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.tipLB)
            make.top.equalTo(self.tipLB.snp.bottom).offset(AdaptScale(100))
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
        }
        
        self.passTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.tipLB)
            make.top.equalTo(self.mailTF.snp.bottom).offset(16)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
        }
        
        self.registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.passTF.snp.bottom).offset(AdaptScale(40))
        }
        
        
    }
    
    func setupUI() {
        self.mailTF = FMTextField.init(frame: CGRect.zero)
        self.mailTF.cornerRadius = 15;
        self.mailTF.tintColor = CommonColor.mainRed.color
        self.mailTF.backgroundColor = CommonColor.cellbackgroud.color
        self.mailTF.attributedPlaceholder = FunnyFm.attributePlaceholder("邮箱".localized)
        self.mailTF.returnKeyType = .done
        self.mailTF.font = h_bfont(fontsize4)
        self.mailTF.textColor = CommonColor.title.color
        self.mailTF.delegate = self.mailTF
        self.view.addSubview(self.mailTF)
        
        self.passTF = FMTextField.init(frame: CGRect.zero)
        self.passTF.cornerRadius = 15;
        self.passTF.tintColor = CommonColor.mainRed.color
        self.passTF.backgroundColor = CommonColor.cellbackgroud.color
        self.passTF.attributedPlaceholder = FunnyFm.attributePlaceholder("密码（6位）".localized)
        self.passTF.returnKeyType = .done
        self.passTF.font = h_bfont(fontsize4)
        self.passTF.textColor = CommonColor.title.color
        self.passTF.delegate = self.passTF

        self.view.addSubview(self.passTF)
    }
}
