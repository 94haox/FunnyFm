//
//  ChapterDetailViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Kingfisher

class ChapterDetailViewController: BaseViewController,FMPlayerManagerDelegate {
    
    var chapter: Chapter?
    
    var backBtn: UIButton?
    
    var titleLB: UILabel?
    
    var subTitle: UILabel?
    
    var likeBtn: UIButton?
    
    var rateBtn: UIButton?
    
    var downBtn: UIButton?
    
    var sleepBtn: UIButton?
    
    var blackImageView: UIImageView?
    
    var coverImageView: UIImageView?
    
    var progressLine: ChapterProgressView?
    
    var playBtn : AnimationButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dw_addSubviews()
        self.dw_addConstraints()
        self.view.backgroundColor = .white
        FMPlayerManager.shared.delegate = self
        self.sh_interactivePopDisabled = true
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



// MARK: FMPlayerManagerDelegate
extension ChapterDetailViewController {
    
    @objc func tapPlayBtnAction(btn:UIButton){
        btn.isSelected = !self.playBtn!.isSelected
        if btn.isSelected {
            FMPlayerManager.shared.play()
        }else{
            FMPlayerManager.shared.pause()

        }
    }
    
    func playerStatusDidChanged(isCanPlay: Bool) {
        self.playBtn!.isHidden = !isCanPlay
    }
    
    func playerDidPlay() {
        
    }
    
    func playerDidPause() {
        //        self.isPlaying = false
    }
    
    func managerDidChangeProgress(progess: Double) {
        self.progressLine!.changeProgress(progress: progess, current: FunnyFm.formatIntervalToMM(FMPlayerManager.shared.currentTime), total: FunnyFm.formatIntervalToMM(FMPlayerManager.shared.totalTime))
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
    
    @objc func changeRateAction(btn: UIButton){
        switch btn.titleLabel?.text {
        case "1x":
            btn.setTitle("1.5x", for: .normal)
            break
        case "2x":
            btn.setTitle("1x", for: .normal)
            break
        case "1.5x":
            btn.setTitle("2x", for: .normal)
            break
        default:
            break
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
            make.top.equalToSuperview().offset(AdaptScale(60))
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
            make.top.equalTo(self.blackImageView!.snp.bottom).offset(AdaptScale(77))
            make.right.equalTo(self.view.snp.centerX).offset(-32)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        })
        
        self.rateBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.blackImageView!.snp.bottom).offset(AdaptScale(77))
            make.left.equalTo(self.view.snp.centerX).offset(32)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        })
        
        self.downBtn?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.likeBtn!)
            make.left.equalTo(self.rateBtn!.snp.right).offset(AdaptScale(74))
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        })
        
        self.sleepBtn?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.likeBtn!)
            make.right.equalTo(self.likeBtn!.snp.left).offset(-74)
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
        
        self.sleepBtn = UIButton.init(type: .custom)
        self.sleepBtn?.imageView?.contentMode = .scaleAspectFit
        self.sleepBtn?.setImage(UIImage.init(named: "timer-sleep"), for: .normal)
        self.view.addSubview(self.sleepBtn!)
        
        self.rateBtn = UIButton.init(type: .custom)
        self.rateBtn?.setTitle("1x", for: .normal)
        self.rateBtn?.titleLabel?.font = h_bfont(fontsize6)
        self.rateBtn?.setTitleColor(CommonColor.title.color, for: .normal)
        self.rateBtn?.addTarget(self, action: #selector(changeRateAction(btn:)), for: .touchUpInside)
        self.view.addSubview(self.rateBtn!)
        
        self.progressLine = ChapterProgressView()
        self.progressLine?.cycleW = 18
        self.progressLine?.fontSize = fontsize0
        self.view.addSubview(self.progressLine!)
        
        self.playBtn = AnimationButton.init(type: .custom)
        self.playBtn?.setImage(UIImage.init(named: "play-red"), for: .normal)
        self.playBtn?.setImage(UIImage.init(named: "play-high"), for: .highlighted)
        self.playBtn?.setImage(UIImage.init(named: "pause-red"), for: .selected)
        self.playBtn?.isSelected = FMPlayerManager.shared.isPlay
        self.playBtn!.addTarget(self, action: #selector(tapPlayBtnAction(btn:)), for: .touchUpInside)
        self.playBtn?.cornerRadius = 30
        self.playBtn?.addShadow(ofColor: CommonColor.mainRed.color, opacity: 0.8)
        self.view.addSubview(self.playBtn!)
    }

    
}
