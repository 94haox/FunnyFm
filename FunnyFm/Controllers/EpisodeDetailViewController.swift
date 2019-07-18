//
//  EpisodeDetailViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/15.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController {

    
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var desLB: UILabel!
    @IBOutlet weak var podLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    var episode: Episode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		do{
			let srtData = self.episode.intro.data(using: String.Encoding.unicode, allowLossyConversion: true)!
			let attrStr = try NSMutableAttributedString(data: srtData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
			attrStr.enumerateAttributes(in: NSRange.init(location: 0, length: attrStr.length), options: NSAttributedString.EnumerationOptions.reverse) {[weak attrStr] (attr, range, lef) in
				attr.keys.forEach({ (key) in
					if key == .font {
						let font = attr[key] as! UIFont
						var replaceFont = pfont(font.pointSize)
						if font.pointSize < 14 {
							replaceFont = pfont(14)
						}
						attrStr?.addAttributes([NSAttributedString.Key.font : replaceFont], range: range)
					}
					
					if key == .link {
						attrStr?.addAttributes([.foregroundColor : CommonColor.mainRed.color], range: range)
						attrStr?.addAttributes([.strokeColor : CommonColor.mainRed.color], range: range)
						print(range)
					}
				})
			}
			self.desLB.attributedText = attrStr;
		}catch _ as NSError {
			self.desLB.text = self.episode.intro;
		}
		
//		self.desLB.text = self.episode.intro;
        self.titleLB.text = self.episode.title
		self.dateLB.text = self.episode.pubDate
		self.podLB.text = self.episode.author
		self.duration.text = FunnyFm.formatIntervalToString(NSInteger(self.episode.duration))
        self.containerView.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.desLB).offset(30)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController()
    }
    
}
