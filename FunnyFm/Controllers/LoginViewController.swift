//
//  LoginViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/4.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoImageView.addShadow()
        self.logoImageView.cornerRadius = 15;
        self.view.addSubview(self.mailTF)
        self.view.addSubview(self.passTF)
        self.view.addSubview(self.confirmBtn)
        self.view.addSubview(self.wechatBtn)
        
        self.mailTF.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.logoImageView.snp.bottom).offset(AdaptScale(100))
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
        }
        
        self.passTF.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mailTF.snp.bottom).offset(16)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
        }
        
        self.confirmBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.passTF.snp.bottom).offset(25)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
        }
        
        self.wechatBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.confirmBtn.snp.bottom).offset(25)
            make.size.equalTo(CGSize.init(width: 35, height: 35))
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEidted))
        self.view.addGestureRecognizer(tap)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FMToolBar.shared.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FMToolBar.shared.isHidden = false
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func endEidted(){
        self.view.endEditing(true)
    }
    
    
    lazy var confirmBtn :UIButton = {
       let btn = UIButton.init(type: .custom)
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = pfont(fontsize4)
        btn.backgroundColor = CommonColor.mainRed.color
        btn.cornerRadius = 8;
        return btn
    }()
    
    lazy var wechatBtn :UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "wechat"), for: .normal)
        return btn
    }()
    
    lazy var mailTF : FMTextField = {
        let tf = FMTextField.init(frame: CGRect.zero)
        tf.cornerRadius = 15;
        tf.tintColor = CommonColor.mainRed.color
        tf.backgroundColor = CommonColor.cellbackgroud.color
        tf.placeholder = "邮箱"
        tf.returnKeyType = .done
        tf.font = pfont(fontsize4)
        tf.textColor = CommonColor.title.color
        tf.delegate = tf
        tf.setValue(p_bfont(12), forKeyPath: "_placeholderLabel.font")
        tf.setValue(CommonColor.content.color, forKeyPath: "_placeholderLabel.textColor")
        return tf
    }()
    
    lazy var passTF : FMTextField = {
        let tf = FMTextField.init(frame: CGRect.zero)
        tf.cornerRadius = 15;
        tf.tintColor = CommonColor.mainRed.color
        tf.backgroundColor = CommonColor.cellbackgroud.color
        tf.placeholder = "密码"
        tf.returnKeyType = .done
        tf.font = pfont(fontsize4)
        tf.textColor = CommonColor.title.color
        tf.delegate = tf
        tf.setValue(p_bfont(12), forKeyPath: "_placeholderLabel.font")
        tf.setValue(CommonColor.content.color, forKeyPath: "_placeholderLabel.textColor")
        return tf
    }()
    
}
