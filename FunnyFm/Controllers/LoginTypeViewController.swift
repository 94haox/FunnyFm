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
	
	
	@IBOutlet weak var ggLoginBtn: GIDSignInButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		GIDSignIn.sharedInstance().delegate = self
		GIDSignIn.sharedInstance()?.uiDelegate = self
		GIDSignIn.sharedInstance()?.clientID = "491413064388-cnaplmj5h8bah503k27a71ciiok1acbs.apps.googleusercontent.com"
		ggLoginBtn.style = .wide
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginTypeViewController :GIDSignInDelegate {
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		
	}
	
	
}


extension LoginTypeViewController: GIDSignInUIDelegate {
	func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
		
	}
	
	func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
		
	}
	
	
}
