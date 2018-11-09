//
//  DemoCollectionViewCell.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import expanding_collection
import Kingfisher

class PodListCollectionViewCell: BasePageCollectionCell {

    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet var customTitle: UILabel!
    @IBOutlet weak var customDes: UILabel!
    @IBOutlet weak var updateTime: UILabel!
    @IBOutlet weak var countLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        frontImageView.layer.cornerRadius = 5;
        frontImageView.layer.masksToBounds = true
        customDes.textColor = .white
        updateTime.textColor = CommonColor.subtitle.color
        countLB.textColor = CommonColor.subtitle.color
        customTitle.layer.shadowRadius = 2
        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTitle.layer.shadowOpacity = 0.2
        
    }
    
    
    func configCell(pod: Pod) {
        self.backgroundImageView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: pod.img)!))
        self.frontImageView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: pod.img)!))
        self.customDes.text = pod.des
        self.customTitle.text = pod.name
        self.updateTime.text = "最近更新："+pod.update_time
        self.countLB.text = "共 " + String(pod.count) + " 期"
    }
}
