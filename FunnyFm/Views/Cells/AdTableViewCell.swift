//
//  AdTableViewCell.swift
//  FunnyFm
//
//  Created by wt on 2020/3/23.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit


class AdTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = R.color.ffWhite()
    }
    
    func render(ads: GDTNativeExpressAdView) {
        self.contentView.removeSubviews()
        self.contentView.addSubview(ads)
        ads.backgroundColor = R.color.ffWhite()
        ads.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
