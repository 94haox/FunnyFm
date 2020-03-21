//
//  LoginTypeViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/9.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import GoogleSignIn


class LoginTypeViewController: UIViewController {
	
	var viewModel: LoginViewModel = LoginViewModel()
	@IBOutlet weak var ggLoginBtn: GIDSignInButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.viewModel.delegate = self;
		GIDSignIn.sharedInstance().delegate = self
		GIDSignIn.sharedInstance()?.clientID = googleSigninKey
		GIDSignIn.sharedInstance()?.presentingViewController = self
		ggLoginBtn.style = .wide
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = true
	}

	@IBAction func loginWithEmail(_ sender: Any) {
		let login = NeLoginViewController.init()
		self.navigationController?.pushViewController(login)
	}
	
	@IBAction func backAction(_ sender: Any) {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	

}

extension LoginTypeViewController: ViewModelDelegate {
	func viewModelDidGetDataSuccess() {
		Hud.shared.hide()
		HorizonHUD.showSuccess("登录成功".localized)
		NotificationCenter.default.post(name: NSNotification.Name.init(kParserNotification), object: nil)
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
		Hud.shared.hide()
		SwiftNotice.showText(msg!)
	}
}


extension LoginTypeViewController :GIDSignInDelegate {
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if error.isSome {
			SwiftNotice.showText(error.localizedDescription)
			return;
		}
		Hud.shared.show(on: self.view)
		var params:[String : Any] = [:]
		params["type"] = "google"
		params["google_userid"] = user.userID
		params["google_token"] = user.authentication.accessToken
		params["name"] = user.profile.name
		if user.profile.hasImage {
			params["avatar"] = user.profile.imageURL(withDimension: 240)?.absoluteString
		}
		
		self.viewModel.login(googleData: params)
	}
	
	
}

