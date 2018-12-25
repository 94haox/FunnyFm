//
//  ChapterProgressView.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/24.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class ChapterProgressView: UIView {
    
    
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
        self.nowDot.text = " " + current + " "
    }
    
    func dw_addSubviews(){
        self.addSubview(self.totalProgress)
        self.addSubview(self.currentProgress)
        self.addSubview(self.allDot)
//        self.addSubview(self.nowDot)
        self.addSubview(self.nowCycle)
        self.totalProgress.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.height.equalTo(4)
            make.center.equalToSuperview()
        }
        
        self.currentProgress.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(4)
            make.centerY.equalToSuperview()
            make.width.equalTo(0)
        }
        
        self.allDot.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(8)
            make.centerX.equalTo(self.totalProgress.snp.right)
        }
        
//        self.nowDot.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
////            make.width.equalTo(30)
//            make.height.equalTo(8)
//            make.centerX.equalTo(self.currentProgress.snp.right)
//        }
        
        self.nowCycle.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 10, height: 10))
            make.centerX.equalTo(self.currentProgress.snp.right)
        }
        
        
        
    }
    
    
    lazy var nowCycle : UIView = {
        let view = UIView.init()
        view.backgroundColor = CommonColor.mainPink.color
        view.borderWidth = 2
        view.borderColor = .white
        view.cornerRadius = 5
        view.addShadow()
        return view
    }()
    
    lazy var nowDot : UILabel = {
        let lb = UILabel.init(text: " 00:00 ")
        lb.textColor = CommonColor.title.color
        lb.layer.backgroundColor = UIColor.white.cgColor
        lb.textAlignment = .center
        lb.font = pfont(6)
        lb.cornerRadius = 4
        lb.addShadow()
//        lb.layer.masksToBounds = false
        return lb
    }()
    
    lazy var allDot : UILabel = {
        let lb = UILabel.init(text: " 00:00 ")
        lb.textColor = CommonColor.title.color
        lb.textAlignment = .center
        lb.layer.backgroundColor = UIColor.white.cgColor
        lb.font = pfont(6)
        lb.cornerRadius = 4
        lb.addShadow()
        lb.layer.masksToBounds = false
        return lb
    }()
    
    lazy var totalProgress: UIView = {
        let view = UIView.init()
        view.backgroundColor = RGB(236, 238, 240)
        view.cornerRadius = 2.0
        return view
    }()
    
    lazy var currentProgress: UIView = {
        let view = UIView.init()
        view.backgroundColor = CommonColor.mainPink.color
        view.cornerRadius = 2.0
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
