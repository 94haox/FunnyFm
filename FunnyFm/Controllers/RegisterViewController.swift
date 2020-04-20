//
//  RegisterViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/4.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, ViewModelDelegate {

    @IBOutlet var tipLB: UIView!
    
    @IBOutlet weak var registerBtn: RoundedButton!
    
    var viewModel: LoginViewModel = LoginViewModel()
    
    var mailTF : FMTextField!
    
    var passTF : FMTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.dw_addSubviews()
        self.viewModel.delegate = self
        self.dw_addTouchEndEdit()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = true
	}

    @IBAction func registerAction(_ sender: Any) {
        self.endEidted()
                
        if let mail = self.mailTF.text?.trim(), mail.count < 1 {
            SwiftNotice.showText("请输入邮箱地址".localized)
            return
        }else if let mail = self.mailTF.text?.trim(), !VaildManager.isMail(mail) {
            SwiftNotice.showText("请输入正确邮箱地址".localized)
            return
        }
        
        if let pwd = self.passTF.text?.trim(), pwd.count < 1 {
            SwiftNotice.showText("请输入密码".localized)
            return
        }else if let pwd = self.passTF.text?.trim(), pwd.count != 6{
            SwiftNotice.showText("请输入正确密码（六位）".localized)
            return
        }
        self.showLoading()
        self.viewModel.register(mail: self.mailTF.text!.trim(), and: self.passTF.text!.trim())
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController()
    }
	
    func showLoading() { 
        self.registerBtn.isBusy = true
    }
    
    func hideLoading(){
        self.registerBtn.isBusy = false
    }

}


extension RegisterViewController {
    
    func viewModelDidGetDataSuccess() {
        self.hideLoading()
		UserDefaults.standard.set(self.viewModel.user!.userId, forKey: "userId")
		UserDefaults.standard.set(true, forKey: "isLogin")
		UserDefaults.standard.synchronize()
		HorizonHUD.showSuccess("登录成功".localized)
		NotificationCenter.default.post(name: NSNotification.Name.init(kParserNotification), object: nil)
		self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
        self.hideLoading()
        SwiftNotice.showText(msg!)
    }
    
    
}

extension RegisterViewController {
    
    func dw_addSubviews() {
        
        self.view.backgroundColor = CommonColor.white.color
        
        self.mailTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.tipLB)
            make.top.equalTo(self.tipLB.snp.bottom).offset(100.auto())
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
            make.top.equalTo(self.passTF.snp.bottom).offset(40.auto())
        }
        
        
    }
    
    func setupUI() {
        self.mailTF = FMTextField.init(frame: CGRect.zero)
        self.mailTF.cornerRadius = 15;
        self.mailTF.tintColor = R.color.mainRed()!
        self.mailTF.backgroundColor = CommonColor.cellbackgroud.color
        self.mailTF.attributedPlaceholder = FunnyFm.attributePlaceholder("邮箱".localized)
        self.mailTF.returnKeyType = .done
        self.mailTF.font = h_bfont(fontsize4)
        self.mailTF.textColor = CommonColor.title.color
        self.mailTF.delegate = self.mailTF
        self.view.addSubview(self.mailTF)
        
        self.passTF = FMTextField.init(frame: CGRect.zero)
        self.passTF.cornerRadius = 15;
        self.passTF.tintColor = R.color.mainRed()!
        self.passTF.backgroundColor = CommonColor.cellbackgroud.color
        self.passTF.attributedPlaceholder = FunnyFm.attributePlaceholder("密码（6位）".localized)
        self.passTF.returnKeyType = .done
        self.passTF.font = h_bfont(fontsize4)
        self.passTF.textColor = CommonColor.title.color
        self.passTF.delegate = self.passTF

        self.view.addSubview(self.passTF)
    }
}
