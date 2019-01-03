//
//  PlayerDetailViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Kingfisher
import pop

class PlayerDetailViewController: BaseViewController,FMPlayerManagerDelegate {
    
    var chapter: Episode?
    
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
    
    var downProgressLayer: CAShapeLayer!
    
    var downBackView: UIView!
	
	var downloadManager: DownloadManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dw_addSubviews()
        self.dw_addConstraints()
        self.view.backgroundColor = .white
        self.sh_interactivePopDisabled = true
		FMPlayerManager.shared.playerDelegate = self
		self.downloadManager = DownloadManager.init()
		if FMPlayerManager.shared.isPlay {
			self.addRotationAnimation()
		}
    }
    
    func addRotationAnimation() {
       PopManager.addRotationAnimation(self.blackImageView!.layer)
    }
    
    func removeRotationAnimation() {
        PopManager.removeRotationAnimation(self.blackImageView!.layer)
    }
    
    
}



// MARK: FMPlayerManagerDelegate
extension PlayerDetailViewController {
    
    func playerStatusDidChanged(isCanPlay: Bool) {
        self.playBtn!.isHidden = !isCanPlay
    }
    
    func playerDidPlay() {
        self.addRotationAnimation()
        self.playBtn!.isSelected = true
    }
    
    func playerDidPause() {
        self.removeRotationAnimation()
        self.playBtn!.isSelected = false
    }
    
    func managerDidChangeProgress(progess: Double, currentTime: Double, totalTime: Double) {
        self.progressLine!.changeProgress(progress: progess, current: FunnyFm.formatIntervalToMM(NSInteger(currentTime)), total: FunnyFm.formatIntervalToMM(NSInteger(totalTime)))
    }
    
}

extension PlayerDetailViewController: DownloadManagerDelegate {
	
	func downloadProgress(progress: Double) {
		if let anim = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd){
			anim.fromValue = self.downProgressLayer.strokeEnd
			anim.toValue = progress
			anim.duration = 0.2
			anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
			self.downProgressLayer.pop_add(anim, forKey: "image_rotaion")
		}
	}
	
	func didDownloadSuccess(fileUrl: String?) {
		if fileUrl.isNone{
			SwiftNotice.showText("下载失败")
			return
		}
		SwiftNotice.showText("下载成功，您可以在个人中心-我的下载查看")
		if let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY) {
			anim.toValue = NSValue.init(cgPoint: CGPoint.init(x: 1, y: 1))
			anim.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 1.5, y: 1.5))
			anim.springBounciness = 20
			self.downBtn!.layer.pop_add(anim, forKey: "size")
		}
		self.chapter!.download_filpath = fileUrl!
		DatabaseManager.add(download: self.chapter!)
	}
	
	func didDownloadFailure() {
		SwiftNotice.showText("下载失败")
	}
	
}


// MARK: actions
extension PlayerDetailViewController {
    
    @objc func tapPlayBtnAction(btn:UIButton){
        btn.isSelected = !self.playBtn!.isSelected
        if btn.isSelected {
            FMPlayerManager.shared.play()
        }else{
            FMPlayerManager.shared.pause()
        }
    }
    
    @objc func downloadAction(){
		self.downloadManager.delegate = self;
		self.downloadManager.beginDownload(self.chapter!.trackUrl_high)
    }
    
    @objc func setSleepTime(){
        let alertController = UIAlertController.init(title: "定时关闭", message: nil, preferredStyle: .actionSheet)
        let squaterAction = UIAlertAction.init(title: "15分钟后", style: .default) { (action) in
            
        }
        let halfAction = UIAlertAction.init(title: "30分钟后", style: .default){ (action) in
            
        }
        let hourAction = UIAlertAction.init(title: "1小时后", style: .default){ (action) in
            
        }
        let endAction = UIAlertAction.init(title: "播放结束后", style: .default){ (action) in
            
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(squaterAction)
        alertController.addAction(halfAction)
        alertController.addAction(hourAction)
        alertController.addAction(endAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func changeRateAction(btn: UIButton){
        var rate = 1.0;
        switch btn.titleLabel?.text {
        case "1x":
            btn.setTitle("1.5x", for: .normal)
            rate = 1.5
            break
        case "2x":
            btn.setTitle("1x", for: .normal)
            rate = 1
            break
        case "1.5x":
            btn.setTitle("2x", for: .normal)
            rate = 2
            break
        default:
            break
        }
        
        UserDefaults.standard.set(rate, forKey: "playrate")
        UserDefaults.standard.synchronize()
        FMPlayerManager.shared.player?.rate = Float(rate)
        if !FMPlayerManager.shared.isPlay {
            FMPlayerManager.shared.player?.pause()
        }
    }
    
    @objc func back(){
        self.navigationController?.popViewController()
    }
    
    func sleep(with time: String) {
        
    }
}


// MARK:  UI
extension PlayerDetailViewController {
    
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
            make.size.equalTo(CGSize.init(width: 35, height: 25))
        })
        
        self.downBtn?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.likeBtn!)
            make.left.equalTo(self.rateBtn!.snp.right).offset(AdaptScale(70))
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        })
        
        self.downBackView.snp.makeConstraints { (make) in
            make.center.equalTo(self.downBtn!)
            make.size.equalTo(CGSize.init(width: 35, height: 35))
        }
        
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
        self.blackImageView?.addShadow(ofColor: CommonColor.title.color, radius: 10, offset: CGSize.init(width: 1, height: 1), opacity: 0.9)
        self.view.addSubview(self.blackImageView!)
		
		self.coverImageView = UIImageView.init()
		let resource = ImageResource.init(downloadURL: URL.init(string: (self.chapter?.cover_url_high)!)!)
		self.coverImageView!.kf.setImage(with: resource)
		self.coverImageView?.cornerRadius = 70
		self.blackImageView!.addSubview(self.coverImageView!)
        
        self.likeBtn = UIButton.init(type: .custom)
        self.likeBtn?.setImage(UIImage.init(named: "favor-nor"), for: .normal)
        self.likeBtn?.setImage(UIImage.init(named: "favor-sel"), for: .selected)
        self.view.addSubview(self.likeBtn!)
        
        self.downProgressLayer = CAShapeLayer.init()
        let bezier = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 35, height: 35))
        self.downProgressLayer.path = bezier.cgPath
        self.downProgressLayer.fillColor = UIColor.white.cgColor;
        self.downProgressLayer.strokeColor = CommonColor.mainRed.color.cgColor;
        self.downProgressLayer.strokeStart = 0
        self.downProgressLayer.strokeEnd = 0
        self.downProgressLayer.cornerRadius = 3
        self.downProgressLayer.lineWidth = 3
        self.downProgressLayer.lineCap = .round
        
        self.downBackView = UIView.init()
        self.downBackView.layer.addSublayer(self.downProgressLayer)
        self.view.addSubview(self.downBackView)
        
        self.downBtn = UIButton.init(type: .custom)
        self.downBtn?.setImage(UIImage.init(named: "download-black"), for: .normal)
        self.downBtn!.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        self.view.addSubview(self.downBtn!)
        
        
        self.sleepBtn = UIButton.init(type: .custom)
        self.sleepBtn?.imageView?.contentMode = .scaleAspectFit
        self.sleepBtn?.setImage(UIImage.init(named: "timer-sleep"), for: .normal)
        self.sleepBtn?.addTarget(self, action: #selector(setSleepTime), for: .touchUpInside)
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
