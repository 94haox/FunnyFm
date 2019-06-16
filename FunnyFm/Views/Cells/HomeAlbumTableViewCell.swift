//
//  HomeAlbumTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/6.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import Kingfisher
import pop
import Lottie

class HomeAlbumTableViewCell: UITableViewCell {

    
    var playStateView: AnimationView!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var updateLB: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.playStateView = AnimationView.init(name: "play_state")
        self.playStateView.loopMode = .loop
        self.contentView.addSubview(self.playStateView)
        self.playStateView.snp.makeConstraints { (make) in
            make.top.equalTo(self.logoImageView.snp.bottom)
            make.centerX.equalTo(self.logoImageView)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.playStateView.alpha = selected ? 1 : 0
        selected ? self.playStateView.play() : self.playStateView.stop()
    }
    
    
    func configHomeCell(_ episode:Episode){
        self.titleLB.text = episode.title
        self.updateLB.text = episode.pubDate
		self.timeLB.text = String(episode.duration)
		let resource = ImageResource.init(downloadURL: URL.init(string: episode.podCoverUrl)!)
        self.logoImageView.kf.setImage(with: resource)
    }
    
    func configCell(_ episode:Episode){
        self.titleLB.text = episode.title
		self.updateLB.text = episode.pubDate
		self.timeLB.text = String(episode.duration)
       self.logoImageView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: episode.coverUrl)!) )
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.contentView.alpha = 0.5
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.contentView.alpha = 1
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.contentView.alpha = 1
        }
    }
    
}
