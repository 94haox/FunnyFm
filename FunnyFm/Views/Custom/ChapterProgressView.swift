//
//  ChapterProgressView.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/24.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import pop


class ChapterProgressView: UIView {
    
    /// 是否是拖动状态
    var isDrag = false
    
    let feedBackGenertor = UIImpactFeedbackGenerator.init(style: .light)
    
    var beginPoint: CGPoint?
	
	weak var delegate : ChapterProgressDelegate?
    
    var fontSize: CGFloat = 6 {
        didSet{
            self.allDot.font = hfont(fontSize)
            self.nowDot.font = hfont(fontSize)
        }
    }
    
    var progressHeigth: CGFloat = 15
    
    var cycleW: CGFloat = 20 {
        didSet{
            self.nowCycle.cornerRadius = cycleW/2.0
            self.nowCycle.addShadow(ofColor: CommonColor.mainRed.color)
            self.nowCycle.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize.init(width: cycleW, height: cycleW))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dw_addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeProgress(progress:Double, current:String, total:String){
        self.allDot.text = "- " + total
        self.nowDot.text = current
        if self.isDrag {
            return
        }
        self.currentProgress.snp.updateConstraints { (make) in
            make.width.equalTo(Double(self.totalProgress.frame.width) * progress)
        }
        self.layoutIfNeeded()
    }
    
    func dw_addSubviews(){
        self.addSubview(self.totalProgress)
        self.addSubview(self.currentProgress)
        self.addSubview(self.allDot)
        self.addSubview(self.nowDot)
        self.addSubview(self.nowCycle)
		self.currentProgress.addShadow(ofColor: CommonColor.mainRed.color, radius: 5, offset: CGSize.init(width: 2, height: 4), opacity: 0.6)
        
        self.nowDot.snp.makeConstraints { (make) in
            make.top.equalTo(self.nowCycle.snp.bottom).offset(4)
            make.left.equalTo(self.totalProgress)
        }
        
        self.allDot.snp.makeConstraints { (make) in
            make.top.equalTo(self.nowCycle.snp.bottom).offset(4)
            make.right.equalTo(self.totalProgress)
        }
        
        self.totalProgress.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(self.progressHeigth)
            make.centerY.equalToSuperview()
        }
        
        self.currentProgress.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(self.progressHeigth)
            make.centerY.equalToSuperview()
            make.width.equalTo(0)
        }
        
        self.nowCycle.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: self.cycleW, height: self.cycleW))
            make.centerX.equalTo(self.currentProgress.snp.right)
        }
        
    }
    
    
    lazy var nowCycle : UIView = {
        let view = UIView.init()
        view.backgroundColor = CommonColor.mainRed.color
        view.borderWidth = 2
        view.borderColor = .white
        return view
    }()
    
    lazy var nowDot : UILabel = {
        let lb = UILabel.init(text: "00:00")
        lb.textColor = CommonColor.content.color
        lb.textAlignment = .center
        lb.font = h_bfont(self.fontSize)
        return lb
    }()
    
    lazy var allDot : UILabel = {
        let lb = UILabel.init(text: "00:00")
        lb.textColor = CommonColor.content.color
        lb.textAlignment = .center
        lb.font = h_bfont(self.fontSize)
        return lb
    }()
    
    lazy var totalProgress: UIView = {
        let view = UIView.init()
        view.backgroundColor = RGB(236, 238, 240)
        view.cornerRadius = 3
        return view
    }()
    
    lazy var currentProgress: UIView = {
        let view = UIView.init()
        view.backgroundColor = CommonColor.mainRed.color
        view.cornerRadius = 3
        return view;
    }()
    

}

extension ChapterProgressView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.randomElement()
        let point = touch?.location(in: self)
        
        if self.nowCycle.layer.frame.contains(point!) {
            self.beginPoint = point
            self.isDrag = true
            if let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY) {
                anim.toValue = NSValue.init(cgPoint: CGPoint.init(x: 1, y: 1))
                anim.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 1.2, y: 1.2))
                anim.springBounciness = 20
                self.nowCycle.layer.pop_add(anim, forKey: "size")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.isDrag) {
            let touch = touches.randomElement()
            let progressPoint = touch!.location(in: self.totalProgress)
            if progressPoint.x > 0{
                self.feedBackGenertor.impactOccurred()
                var x = progressPoint.x
                if x > self.totalProgress.frame.width {
                    x = self.totalProgress.frame.width
                }
                self.currentProgress.snp.updateConstraints { (make) in
                    make.width.equalTo(x)
                }
				self.layoutIfNeeded()
				self.delegate?.progressDidChange(progress: self.currentProgress.frame.width/self.totalProgress.frame.width)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isDrag = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isDrag {
            let progress = self.currentProgress.frame.width/self.totalProgress.frame.width
            FMPlayerManager.shared.seekToProgress(progress)
        }
        self.isDrag = false
		self.delegate?.progressDidEndDrag()
    }
    
    
}


