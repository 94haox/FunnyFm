//
//  HomeEpisodeCell.swift
//  FunnyFm
//
//  Created by wt on 2020/5/26.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class HomeEpisodeCell: UITableViewCell {

    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var sumryLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    private var tapClosure: (() -> Void)?
    private var tapLogoClosure: (() -> Void)?
    var _episode: Episode?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configHomeCell(_ episode: Episode){
        _episode = episode;
        self.titleLB.text = episode.title
        self.sumryLB.text = episode.intro
        self.timeLB.text = FunnyFm.formatIntervalToString(NSInteger(episode.duration))
        if episode.podCoverUrl.length() > 0 {
            self.iconImageView.loadImage(url: episode.podCoverUrl)
        }else{
            self.iconImageView.loadImage(url: episode.coverUrl)
        }
        
    }
    
    @IBAction func logoTapAction(_ sender: Any) {
        if tapLogoClosure.isSome {
            tapLogoClosure?()
        }
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        guard let episode = _episode else {
            return
        }
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            FMPlayerManager.shared.config(episode)
        }else{
            FMPlayerManager.shared.pause()
        }
        
    }
    
    
}
