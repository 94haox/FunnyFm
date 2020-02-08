//
//  NeLoginViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/6.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Lottie
import FirebaseUI
import GoogleSignIn

class NeLoginViewController: UIViewController, ViewModelDelegate {

    @IBOutlet weak var tipLB: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var nextImageView: UIImageView!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
	
	@IBOutlet weak var ggLoginBtn: UIButton!
	
	var authUI : FUIAuth!
	
	var emptyAnimationView : AnimationView = {
		let view = AnimationView.init(name: "login_anim")
		view.loopMode = .loop
		return view
	}()
    
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
		self.dw_addTouchEndEdit()
		let providers: [FUIAuthProvider] = [
			FUIGoogleAuth(),
		]
		self.authUI = FUIAuth.defaultAuthUI()
		self.authUI.delegate = self;
		self.authUI.providers = providers
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.emptyAnimationView.play()
	}

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func wxLoginAction(_ sender: Any) {
		let authViewController = authUI.authViewController()
 		self.present(authViewController, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.endEidted()
        
        if self.isLoading {
            return
        }
        
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
        UserDefaults.standard.set(self.mailTF.text!, forKey: "lastLoginAccount")
        self.showLoading()
        self.viewModel.login(mail: self.mailTF.text!.trim(), and: self.passTF.text!.trim())
    }
    
    @IBAction func registerAction(_ sender: Any) {
        self.navigationController?.pushViewController(RegisterViewController())
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

extension NeLoginViewController : FUIAuthDelegate{
	
	func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
		
	}
}

extension NeLoginViewController {
    
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


extension NeLoginViewController {
    
    func dw_addSubviews() {
        
        self.mailTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.tipLB)
            make.top.equalTo(self.tipLB.snp.bottom).offset(90.adapt())
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50.adapt())
        }
        
        self.passTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.tipLB)
            make.top.equalTo(self.mailTF.snp.bottom).offset(16)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50.adapt())
        }
        
        self.loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.passTF.snp.bottom).offset(40.adapt())
        }
		
		self.view.addSubview(self.emptyAnimationView)
		self.emptyAnimationView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.tipLB.snp.top).offset(-10.auto())
            make.size.equalTo(CGSize.init(width: 200.auto(), height: 200.auto()))
			make.right.equalToSuperview()
		}
        
        
    }
    
    func setupUI() {
        self.view.backgroundColor = CommonColor.white.color
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
        let account = UserDefaults.standard.object(forKey: "lastLoginAccount")
        if account.isSome {
            self.mailTF.text = (account as! String)
        }
        
        
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
