//
//  HomePodCollectionViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/6.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class HomePodCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(_ pod: iTunsPod) {
        self.logoImageView.loadImage(url: pod.artworkUrl600)
    }

}
