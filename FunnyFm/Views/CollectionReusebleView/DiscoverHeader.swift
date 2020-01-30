//
//  DiscoverHeader.swift
//  FunnyFm
//
//  Created by Duke on 2020/1/30.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class DiscoverHeader: UICollectionReusableView {
	
	let titleLB: UILabel = UILabel.init(text: "Category")
			
	let moreLB: UILabel = UILabel.init(text: "see more")
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupUI()
	}
	
	func config(collection: Collection) {
		self.titleLB.text = collection.collectionName
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


extension DiscoverHeader {
	
	func setupUI(){
		
		titleLB.font = pfont(fontsize6)
		moreLB.font = pfont(fontsize2)
		self.addSubview(titleLB)
		self.addSubview(moreLB)
		
		titleLB.snp.makeConstraints { (make) in
			make.left.equalTo(self).offset(12.auto())
			make.centerY.equalToSuperview()
		}
		
		moreLB.snp.makeConstraints { (make) in
			make.right.equalTo(self).offset(-12.auto())
			make.centerY.equalToSuperview()
		}
		
		
	}
	
}
