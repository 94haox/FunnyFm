//
//  HomeEpisodeTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/28.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Kingfisher

class HomeEpisodeTableViewCell: BaseTableViewCell {

    @IBOutlet weak var logoBackView: UIView!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var desLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.logoBackView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self.logoImageView);
            make.right.equalTo(self.logoImageView).offset(10);
        }
        self.logoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-12)
        }
        self.logoImageView.cornerRadius = 5
        self.logoBackView.cornerRadius = 5
        self.containerView.addShadow(ofColor: UIColor.init(hex: "f3f3f3"), radius: 15, offset: CGSize.init(width: 1, height: 2), opacity: 0.8)
        self.logoBackView.addShadow(ofColor: UIColor.init(hex: "f3f3f3"), radius: 5, offset: CGSize.init(width: 0, height: 5), opacity: 0.8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configHomeCell(_ chapter:Episode){
        self.desLB.text = chapter.intro
        self.titleLB.text = chapter.title
        self.timeLB.text = chapter.pubDate
        let resource = ImageResource.init(downloadURL: URL.init(string: chapter.coverUrl)!)
        self.logoImageView.kf.setImage(with: resource)
    }
    
}
