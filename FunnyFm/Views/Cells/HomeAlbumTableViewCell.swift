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

class HomeAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var playLogoImageView: UIImageView!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var desLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.1) {
            self.playLogoImageView.alpha = selected ? 1 : 0
        }
    }
    
    
    func configHomeCell(_ chapter:Chapter){
        self.desLB.text = chapter.intro
        self.titleLB.text = chapter.title
        self.timeLB.text = chapter.time_until_now
		let resource = ImageResource.init(downloadURL: URL.init(string: chapter.pod_cover_url)!)
//        let image = Image.init(named: "ImagePlaceHolder")
        self.logoImageView.kf.setImage(with: resource)
    }
    
    func configCell(_ chapter:Chapter){
        self.desLB.text = chapter.intro
        self.titleLB.text = chapter.title
        self.timeLB.text = chapter.time_until_now
		
        if(chapter.cover_url_normal.count > 1){
            self.logoImageView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: chapter.cover_url_normal)!))
        }else if(chapter.cover_url_high.count > 1){
            self.logoImageView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: chapter.cover_url_high)!) )
        }
        
    }
    
    func configHistory(_ history:ListenHistoryModel){
        self.desLB.text = history.intro
        self.titleLB.text = history.title
        self.timeLB.text = history.time_until_now
        self.logoImageView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: history.cover_url!)!) )
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
