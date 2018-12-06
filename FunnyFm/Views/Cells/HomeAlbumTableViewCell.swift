//
//  HomeAlbumTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/6.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Kingfisher

class HomeAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var desLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ chapter:Chapter){
        self.desLB.text = chapter.intro
        self.titleLB.text = chapter.title
        self.timeLB.text = chapter.time_until_now
        self.logoImageView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: chapter.cover_url_high)!))
    }
    
}
