//
//  AboutViewController.swift
//  FunnyFm
//
//  Created by wt on 2020/3/20.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import SafariServices


class AboutViewController: BaseViewController {

    @IBOutlet var versionLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLB.text = "关于".localized
        let infoDic = Bundle.main.infoDictionary
        let appVersion = infoDic?["CFBundleShortVersionString"]
        let appBuildVersion = infoDic?["CFBundleVersion"]
        self.versionLB.text = "Version: " + (appVersion as! String) + "(\((appBuildVersion as! String)))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FMToolBar.shared.isHidden = true
    }
       
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if FMToolBar.shared.currentEpisode.isSome {
            FMToolBar.shared.isHidden = false
        }
    }

    @IBAction func useInfoAction(_ sender: Any) {
        let vc = SFSafariViewController.init(url: URL.init(string: "https://live.funnyfm.top/#/terms")!)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func privacyAction(_ sender: Any) {
        let vc = SFSafariViewController.init(url: URL.init(string: "https://live.funnyfm.top/#/policy")!)
        self.present(vc, animated: true, completion: nil)
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
