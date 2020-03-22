//
//  DiscoverHeader.swift
//  FunnyFm
//
//  Created by Duke on 2020/1/30.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class DiscoverHeader: UICollectionReusableView {
	
	let titleLB = UILabel.init(text: "Category")
			
	let moreLB = UILabel.init(text: "")
    
    let subscribeBtn = UIButton.init(type: .custom)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupUI()
	}
	
	func config(collection: PodcastCollection) {
		self.titleLB.text = collection.collectionName
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


extension DiscoverHeader {
	
	func setupUI(){
		
		titleLB.font = p_bfont(fontsize6)
		moreLB.font = pfont(fontsize2)
		moreLB.textColor = CommonColor.content.color
        subscribeBtn.setTitleForAllStates("订阅所有".localized)
        subscribeBtn.setTitleColor(R.color.mainRed(), for: .normal)
        subscribeBtn.titleLabel?.font = pfont(10.auto())
        
		self.addSubview(titleLB)
		self.addSubview(moreLB)
        self.addSubview(subscribeBtn)
		
		titleLB.snp.makeConstraints { (make) in
			make.left.equalTo(self).offset(12.auto())
			make.centerY.equalToSuperview()
		}
		
		moreLB.snp.makeConstraints { (make) in
			make.right.equalTo(self).offset(-12.auto())
			make.centerY.equalToSuperview()
		}
        
        subscribeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-12.auto())
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 50, height: 20))
        }
		
		
	}
	
}
