//
//  SettingTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/13.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class SettingTableViewCell: BaseTableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
    }
    
    func config(dic : Dictionary<String, String>){
        self.titleLB.text = dic["title"]
        self.leftImageView.image = UIImage.init(named: dic["imageName"]!)
        if dic["rightImage"].isSome{
            self.rightImageView.image = UIImage.init(named: dic["rightImage"]!)
            self.rightView.isHidden = self.rightImageView.image.isNone
        }else{
            self.rightView.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
