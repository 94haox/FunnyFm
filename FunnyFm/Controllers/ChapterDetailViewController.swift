//
//  ChapterDetailViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Kingfisher

class ChapterDetailViewController: BaseViewController {
    
    var chapter: Chapter?
    
    var backBtn: UIButton?
    
    var titleLB: UILabel?
    
    var subTitle: UILabel?
    
    var likeBtn: UIButton?
    
    var downBtn: UIButton?
    
    var blackImageView: UIImageView?
    
    var coverImageView: UIImageView?
    
    var progressLine: ChapterProgressView?
    
    var playBtn : UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dw_addSubviews()
        self.dw_addConstraints()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FMToolBar.shared.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FMToolBar.shared.isHidden = false
    }
    
    
}


// MARK: actions
extension ChapterDetailViewController {
    
    @objc func didTapPlayBtnAction(btn:UIButton){
        btn.isSelected = !self.playBtn!.isSelected
        if btn.isSelected {
            FMPlayerManager.shared.play()
        }else{
            FMPlayerManager.shared.pause()
        }
    }
    
    @objc func back(){
        self.navigationController?.popViewController()
    }
}



// MARK:  UI
extension ChapterDetailViewController {
    
    func dw_addConstraints(){
        self.titleLB?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.width.equalTo(200)
        })
        
        self.subTitle?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLB!.snp.bottom).offset(2.5)
        })
        
        self.backBtn?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.titleLB!)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        })
        
        self.blackImageView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.subTitle!.snp.bottom).offset(57)
            make.size.equalTo(CGSize.init(width: 244, height: 244))
        })
		
		self.coverImageView?.snp.makeConstraints({ (make) in
			make.center.equalTo(self.blackImageView!)
			make.size.equalTo(CGSize.init(width: 140, height: 140))
		})
        
        self.likeBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.blackImageView!.snp.bottom).offset(77)
            make.right.equalTo(self.view.snp.centerX).offset(-37)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        })
        
        self.downBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.blackImageView!.snp.bottom).offset(77)
            make.left.equalTo(self.view.snp.centerX).offset(37)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        })
        
        self.progressLine?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(20)
            make.top.equalTo(self.downBtn!.snp.bottom).offset(72)
        })
        
        self.playBtn?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.progressLine!.snp.bottom).offset(72)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        })
        
    }
    
    func dw_addSubviews(){
        self.backBtn = UIButton.init(type: .custom)
        self.backBtn!.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.backBtn?.setImage(UIImage.init(named: "back_black"), for: .normal)
        self.view.addSubview(self.backBtn!)
        
        self.titleLB = UILabel.init(text: self.chapter?.title)
        self.titleLB?.textColor = CommonColor.title.color
        self.titleLB?.font = p_bfont(fontsize6)
        self.view.addSubview(self.titleLB!)
        
        self.subTitle = UILabel.init(text: self.chapter?.pod_name)
        self.subTitle?.textColor = CommonColor.content.color
        self.subTitle?.font = pfont(fontsize0)
        self.view.addSubview(self.subTitle!)
        
        self.blackImageView = UIImageView.init(image: UIImage.init(named: "blackground"))
        self.view.addSubview(self.blackImageView!)
		
		self.coverImageView = UIImageView.init()
		let resource = ImageResource.init(downloadURL: URL.init(string: (self.chapter?.cover_url_high)!)!)
		self.coverImageView!.kf.setImage(with: resource)
		self.coverImageView?.cornerRadius = 70
		self.view.addSubview(self.coverImageView!)
        
        self.likeBtn = UIButton.init(type: .custom)
        self.likeBtn?.setImage(UIImage.init(named: "favor-nor"), for: .normal)
        self.likeBtn?.setImage(UIImage.init(named: "favor-sel"), for: .selected)
        self.view.addSubview(self.likeBtn!)
        
        self.downBtn = UIButton.init(type: .custom)
        self.downBtn?.setImage(UIImage.init(named: "download-black"), for: .normal)
        self.view.addSubview(self.downBtn!)
        
        self.progressLine = ChapterProgressView()
        self.progressLine?.cycleW = 18
        self.progressLine?.fontSize = fontsize0
        self.view.addSubview(self.progressLine!)
        
        self.playBtn = UIButton.init(type: .custom)
        self.playBtn?.setImage(UIImage.init(named: "play-red"), for: .normal)
        self.playBtn?.setImage(UIImage.init(named: "pause-red"), for: .selected)
        self.playBtn?.backgroundColor = .white
        self.playBtn?.isSelected = FMPlayerManager.shared.isPlay
        self.playBtn!.addTarget(self, action: #selector(didTapPlayBtnAction(btn:)), for: .touchUpInside)
        self.view.addSubview(self.playBtn!)
    }

    
}
