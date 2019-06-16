//
//  HomePodCollectionViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/6.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Kingfisher

class HomePodCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(_ pod: iTunsPod) {
        self.logoImageView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: pod.artworkUrl600)!))
    }

}
