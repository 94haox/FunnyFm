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
    
    var fontSize: CGFloat = 6 {
        didSet{
            self.allDot.font = hfont(fontSize)
            self.nowDot.font = hfont(fontSize)
        }
    }
    
    var progressHeigth: CGFloat = 4
    
    var cycleW: CGFloat = 10 {
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
        self.allDot.text = total
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
        
        self.nowDot.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(2)
        }
        
        self.allDot.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-2)
        }
        
        self.totalProgress.snp.makeConstraints { (make) in
            make.left.equalTo(self.nowDot.snp.right).offset(10)
            make.right.equalTo(self.allDot.snp.left).offset(-10)
            make.height.equalTo(self.progressHeigth)
            make.centerY.equalToSuperview()
        }
        
        self.currentProgress.snp.makeConstraints { (make) in
            make.left.equalTo(self.nowDot.snp.right).offset(10)
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
        view.borderWidth = 1
        view.borderColor = .white
        view.cornerRadius = self.cycleW/2
        view.addShadow(ofColor: CommonColor.mainRed.color)
        return view
    }()
    
    lazy var nowDot : UILabel = {
        let lb = UILabel.init(text: "00:00:00")
        lb.textColor = CommonColor.content.color
        lb.textAlignment = .center
        lb.font = hfont(self.fontSize)
        return lb
    }()
    
    lazy var allDot : UILabel = {
        let lb = UILabel.init(text: "00:00:00")
        lb.textColor = CommonColor.content.color
        lb.textAlignment = .center
        lb.font = hfont(self.fontSize)
        return lb
    }()
    
    lazy var totalProgress: UIView = {
        let view = UIView.init()
        view.backgroundColor = RGB(236, 238, 240)
        view.cornerRadius = self.progressHeigth/2.0
        return view
    }()
    
    lazy var currentProgress: UIView = {
        let view = UIView.init()
        view.backgroundColor = CommonColor.mainRed.color
        view.cornerRadius = self.progressHeigth/2.0
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
                anim.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 1.5, y: 1.5))
                anim.springBounciness = 30
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
    }
    
    
}


