//
//  NeLoginViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/6.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class NeLoginViewController: BaseViewController, ViewModelDelegate {

    @IBOutlet weak var tipLB: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var nextImageView: UIImageView!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var isLoading = false
    
    var viewModel: LoginViewModel = LoginViewModel()
    
    var mailTF : FMTextField!
    
    var passTF : FMTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.isHidden = true
        self.setupUI()
        self.dw_addSubviews()
        self.viewModel.delegate = self;

        // Do any additional setup after loading the view.
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func wxLoginAction(_ sender: Any) {
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.endEidted()
        
        if self.isLoading {
            return
        }
        
        if let mail = self.mailTF.text, mail.count < 1 {
            SwiftNotice.showText("请输入邮箱地址")
            return
        }else if let mail = self.mailTF.text, !VaildManager.isMail(mail) {
            SwiftNotice.showText("请输入正确邮箱地址")
            return
        }
        
        if let pwd = self.passTF.text, pwd.count < 1 {
            SwiftNotice.showText("请输入密码")
            return
        }else if let pwd = self.passTF.text, pwd.count != 6{
            SwiftNotice.showText("请输入正确密码（六位）")
            return
        }
        UserDefaults.standard.set(self.mailTF.text!, forKey: "lastLoginAccount")
        self.showLoading()
        self.viewModel.login(mail: self.mailTF.text!, and: self.passTF.text!)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        self.navigationController?.pushViewController(RegisterViewController())
    }
    
    @objc func endEidted(){
        self.view.endEditing(true)
    }
    
    func showLoading() {
        self.isLoading = true
        self.loadingView.isHidden = false
        self.nextImageView.isHidden = true
        self.loadingView.startAnimating()
    }
    
    func hideLoading(){
        self.isLoading = false
        self.loadingView.isHidden = true
        self.nextImageView.isHidden = false
        self.loadingView.stopAnimating()
    }

}

extension NeLoginViewController {
    
    func viewModelDidGetDataSuccess() {
        self.hideLoading()
//        UserCenter.shared.userId = self.viewModel.user!.userId
//        UserCenter.shared.isLogin = true
        UserDefaults.standard.set(self.viewModel.user!.userId, forKey: "userId")
        UserDefaults.standard.set(true, forKey: "isLogin")
        UserDefaults.standard.synchronize()
        HorizonHUD.showSuccess("登录成功")
        self.navigationController?.popViewController()
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
        self.hideLoading()
        SwiftNotice.showText(msg!)
    }
    
}


extension NeLoginViewController {
    
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
        
        self.loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.passTF.snp.bottom).offset(AdaptScale(40))
        }
        
        
    }
    
    func setupUI() {
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEidted))
        self.view.addGestureRecognizer(tap)
        
        self.mailTF = FMTextField.init(frame: CGRect.zero)
        self.mailTF.cornerRadius = 15;
        self.mailTF.tintColor = CommonColor.mainRed.color
        self.mailTF.backgroundColor = CommonColor.cellbackgroud.color
        self.mailTF.placeholder = "邮箱"
        self.mailTF.returnKeyType = .done
        self.mailTF.font = h_bfont(fontsize4)
        self.mailTF.textColor = CommonColor.title.color
        self.mailTF.delegate = self.mailTF
        self.mailTF.setValue(p_bfont(12), forKeyPath: "_placeholderLabel.font")
        self.mailTF.setValue(CommonColor.content.color, forKeyPath: "_placeholderLabel.textColor")
        self.view.addSubview(self.mailTF)
        let account = UserDefaults.standard.object(forKey: "lastLoginAccount")
        if account.isSome {
            self.mailTF.text = (account as! String)
        }
        
        
        self.passTF = FMTextField.init(frame: CGRect.zero)
        self.passTF.cornerRadius = 15;
        self.passTF.tintColor = CommonColor.mainRed.color
        self.passTF.backgroundColor = CommonColor.cellbackgroud.color
        self.passTF.placeholder = "密码（6位）"
        self.passTF.returnKeyType = .done
        self.passTF.font = h_bfont(fontsize4)
        self.passTF.textColor = CommonColor.title.color
        self.passTF.delegate = self.passTF
        self.passTF.setValue(p_bfont(12), forKeyPath: "_placeholderLabel.font")
        self.passTF.setValue(CommonColor.content.color, forKeyPath: "_placeholderLabel.textColor")
        self.view.addSubview(self.passTF)
        
        
    }
    
}
