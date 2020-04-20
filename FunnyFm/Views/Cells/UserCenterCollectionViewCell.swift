//
//  UserCenterCollectionViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class UserCenterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var subtitleLB: UILabel!
    @IBOutlet weak var imageBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLB.textColor = R.color.titleColor()
        self.subtitleLB.textColor = R.color.content()
        self.cornerRadius = 15.0
        self.addShadow(ofColor: R.color.background()!, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        self.backgroundColor = R.color.whiteBackground()
        self.imageBackgroundView.backgroundColor = R.color.ffWhite()
        self.logoImageView.tintColor = R.color.mainRed()!
    }
    
    func configCell(_ dic: [String:String]){
        self.titleLB.text = dic["title"]
        self.subtitleLB.text = dic["subtitle"]
        self.logoImageView.image = UIImage.init(named: dic["imageName"]!)?.tintImage
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.5
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle == .dark {
            self.addShadow(ofColor: CommonColor.background.color, radius: 10, offset: CGSize.init(width: 0, height: 1), opacity: 1)
        }else{
            self.cleanShadow()
        }
    }
}
