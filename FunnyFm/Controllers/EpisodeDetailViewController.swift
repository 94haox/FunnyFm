//
//  EpisodeDetailViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/15.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController {

    
	@IBOutlet weak var copyRightLB: UILabel!
	@IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var containerView: UIView!
	@IBOutlet weak var desTextView: UITextView!
	
    @IBOutlet weak var podLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    var episode: Episode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let pod = DatabaseManager.getItunsPod(collectionId: episode.collectionId)
		self.copyRightLB.text = pod?.copyRight
		self.desTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: CommonColor.mainRed.color]
		self.desTextView.showsVerticalScrollIndicator = false
        self.titleLB.text = self.episode.title
		self.dateLB.text = self.episode.pubDate
		self.podLB.text = self.episode.author
		self.duration.text = FunnyFm.formatIntervalToString(NSInteger(self.episode.duration))
		
		
		
		guard self.episode.intro.contains("<") else {
			self.desTextView.text = self.episode.intro;
			return
		}
		
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
			self.desTextView.attributedText = attrStr;
		}catch _ as NSError {
			self.desTextView.text = self.episode.intro;
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
