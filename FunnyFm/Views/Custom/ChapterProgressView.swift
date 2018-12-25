//
//  ChapterProgressView.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/24.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class ChapterProgressView: UIView {
    
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
            self.nowCycle.addShadow(ofColor: CommonColor.mainPink.color)
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
        self.currentProgress.snp.updateConstraints { (make) in
            make.width.equalTo(Double(self.frame.width) * progress)
        }
        self.layoutIfNeeded()
        self.allDot.text = total
        self.nowDot.text = current
    }
    
    func dw_addSubviews(){
        self.addSubview(self.totalProgress)
        self.addSubview(self.currentProgress)
        self.addSubview(self.allDot)
        self.addSubview(self.nowDot)
        self.addSubview(self.nowCycle)
        
        self.nowDot.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(35)
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
        view.backgroundColor = CommonColor.mainPink.color
        view.borderWidth = 1
        view.borderColor = .white
        view.cornerRadius = self.cycleW/2
        view.addShadow(ofColor: CommonColor.mainPink.color)
        return view
    }()
    
    lazy var nowDot : UILabel = {
        let lb = UILabel.init(text: "00:00")
        lb.textColor = CommonColor.content.color
        lb.textAlignment = .center
        lb.font = hfont(self.fontSize)
        return lb
    }()
    
    lazy var allDot : UILabel = {
        let lb = UILabel.init(text: "00:00")
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
        view.backgroundColor = CommonColor.mainPink.color
        view.cornerRadius = self.progressHeigth/2.0
        return view;
    }()
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
