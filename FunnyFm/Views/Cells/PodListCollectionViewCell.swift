//
//  PodListCollectionViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/11.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Kingfisher

class PodListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var updateTimeLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.logoImageView.snp.makeConstraints { (make) in
            make.height.equalTo(self.snp.width)
        }
        self.titleLB.textColor = CommonColor.title.color
        self.updateTimeLB.textColor = CommonColor.subtitle.color
        // Initialization code
    }
    
    func configCell(_ pod: iTunsPod){
        self.logoImageView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: pod.artworkUrl600)!))
        self.titleLB.text = pod.trackName
        self.updateTimeLB.text = pod.releaseDate
    }

}
