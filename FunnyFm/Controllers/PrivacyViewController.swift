//
//  PrivacyViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/9.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Lottie

class PrivacyViewController: UIViewController {

    @IBOutlet weak var notiBgView: UIView!
    
    var notiAnimationView: AnimationView = AnimationView.init(name: "notification_ad")
    
    @IBOutlet weak var authorBtn: RoundedButton!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notiBgView.addSubview(self.notiAnimationView)
        self.notiAnimationView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        self.notiAnimationView.loopMode = .loop
        self.notiAnimationView.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.reset()
    }

    func reset() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @IBAction func toMainAction(_ sender: Any) {
		let emptyVC = EmptyMainViewController.init()
		self.navigationController?.pushViewController(emptyVC, animated: true)
    }
	
    @IBAction func authorAction(_ sender: Any) {
        self.authorBtn.isBusy = true
        NotificationCenter.default.post(name: Notification.setupNotification, object: nil)
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self](_) in
            UNUserNotificationCenter.current().getNotificationSettings { (setting) in
                guard setting.authorizationStatus != .notDetermined else {
                    return
                }
                DispatchQueue.main.async {
                    self?.authorBtn.isBusy = false
                    self?.reset()
                    if setting.authorizationStatus == .authorized {
                        self?.authorBtn.setTitle("已获取授权", for: .normal)
                    }else{
                        self?.authorBtn.setTitle("授权已被拒绝", for: .normal)
                    }
                }
            }
        }
    }
    

}
