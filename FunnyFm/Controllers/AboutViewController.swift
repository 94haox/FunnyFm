//
//  AboutViewController.swift
//  FunnyFm
//
//  Created by wt on 2020/3/20.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import SafariServices
import SwiftUI


class AboutViewController: BaseViewController {

    @IBOutlet var versionLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于".localized
        let infoDic = Bundle.main.infoDictionary
        let appVersion = infoDic?["CFBundleShortVersionString"]
        let appBuildVersion = infoDic?["CFBundleVersion"]
        self.versionLB.text = "Version: " + (appVersion as! String) + "(\((appBuildVersion as! String)))"
    }

    @IBAction func useInfoAction(_ sender: Any) {
        let termView = TermView() // swiftUIView is View
        let viewCtrl = UIHostingController(rootView: termView)
		self.present(viewCtrl, animated: true, completion: nil)
    }
    
    @IBAction func privacyAction(_ sender: Any) {
        let termView = PolicyView() // swiftUIView is View
        let viewCtrl = UIHostingController(rootView: termView)
		self.presentAsStork(viewCtrl, height: kScreenHeight/2.0)
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
