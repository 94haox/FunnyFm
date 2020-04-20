//
//  AppleLoginTypeViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/24.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import GoogleSignIn

#if canImport(AuthenticationServices)
import AuthenticationServices
#endif

class AppleLoginTypeViewController: UIViewController {
	
	var viewModel: LoginViewModel = LoginViewModel()
	var appleBtn: ASAuthorizationAppleIDButton! = ASAuthorizationAppleIDButton.init(type: .signIn, style: .black)
	var tipLB: UILabel! = UILabel.init(text: "- or -")
	var emailBtn: UIButton! = UIButton.init(type: .custom)
	var googleBtn: GIDSignInButton! = GIDSignInButton.init()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = CommonColor.white.color
		self.viewModel.delegate = self;
		GIDSignIn.sharedInstance().delegate = self
		GIDSignIn.sharedInstance()?.clientID = googleSigninKey
		GIDSignIn.sharedInstance()?.presentingViewController = self
		self.googleBtn.style = .wide
		
		self.appleBtn.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
		self.emailBtn.addTarget(self, action: #selector(loginWithEmail), for: .touchUpInside)
		self.emailBtn.setTitle("邮箱登录".localized, for: .normal)
		self.emailBtn.titleLabel?.font = p_bfont(12)
		self.emailBtn.setTitleColor(R.color.mainRed()!, for: .normal)
		self.tipLB.font = pfont(10)
		self.tipLB.textColor = CommonColor.content.color
		
		self.view.addSubview(self.googleBtn)
		self.view.addSubview(self.emailBtn)
		self.view.addSubview(self.appleBtn)
		self.view.addSubview(self.tipLB)
		
		self.googleBtn.snp.makeConstraints { (make) in
			make.center.equalTo(self.view)
		}
		
		self.appleBtn.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.size.equalTo(self.googleBtn).offset(-4)
			make.bottom.equalTo(self.googleBtn.snp.top).offset(-16)
		}
		
		self.tipLB.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(self.googleBtn.snp.bottom).offset(16)
		}
		
		self.emailBtn.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(self.tipLB.snp.bottom).offset(12)
			make.size.equalTo(self.googleBtn)
		}
		
		
    }

}


//MARK: Actions


extension AppleLoginTypeViewController {
	
	@objc func handleAuthorizationAppleIDButtonPress() {
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.fullName, .email]

		let authorizationController = ASAuthorizationController(authorizationRequests: [request])

		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self

		authorizationController.performRequests()
	}
	
	@objc func loginWithEmail() {
		let login = NeLoginViewController.init()
		self.navigationController?.pushViewController(login)
	}
	
}


extension AppleLoginTypeViewController: ViewModelDelegate {
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



extension AppleLoginTypeViewController: ASAuthorizationControllerDelegate ,ASAuthorizationControllerPresentationContextProviding{
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

			let userIdentifier = appleIDCredential.user
			let fullName = appleIDCredential.fullName
			let identityToken = appleIDCredential.identityToken

			Hud.shared.show(on: self.view)
			var params:[String : Any] = [:]
			params["type"] = "apple"
			params["apple_userid"] = userIdentifier
			
			if identityToken.isSome {
				params["apple_token"] = String.init(data: identityToken!, encoding: .utf8)
			}
			
			if fullName.isSome && (fullName?.nickname).isSome {
				params["name"] = fullName!.nickname!
			}
			
			self.viewModel.login(appleData: params)
		}
	}

	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
	// Handle error.
	}

	/// MARK: ASAuthorizationControllerPresentationContextProviding
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
			return self.view.window!
	}
}

extension AppleLoginTypeViewController :GIDSignInDelegate {
	
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


