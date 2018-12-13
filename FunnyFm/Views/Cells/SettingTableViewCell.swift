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
    @IBOutlet weak var rightView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    func configCell(_ dic: [String : String]){
        print(dic)
//        self.leftImageView.image = UIImage.init(named: image)
    }
    
    func config(dic : Dictionary<String, String>){
        self.titleLB.text = dic["title"]
        self.leftImageView.image = UIImage.init(named: dic["imageName"]!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
