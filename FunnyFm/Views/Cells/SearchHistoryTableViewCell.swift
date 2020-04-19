//
//  SearchHistoryTableViewCell.swift
//  FunnyFm
//
//  Created by wt on 2020/4/19.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {

    @IBOutlet var titleLB: UILabel!
    
    var removeBlock: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = R.color.ffWhite()
    }

    func render(string: String) {
        self.titleLB.text = string
    }
    
    @IBAction func removeAction(_ sender: Any) {
        self.removeBlock?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
