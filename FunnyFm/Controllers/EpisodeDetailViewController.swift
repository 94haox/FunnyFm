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
		self.desTextView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
		self.desTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: CommonColor.mainRed.color]
		self.desTextView.showsVerticalScrollIndicator = false
		
		let title = NSAttributedString.init(string: self.episode.title+"\n\n", attributes: [NSAttributedString.Key.font : p_bfont(20), NSAttributedString.Key.foregroundColor: CommonColor.title.color])
		let author = NSAttributedString.init(string: self.episode.author+"\n\n", attributes: [NSAttributedString.Key.font : pfont(14), NSAttributedString.Key.foregroundColor: CommonColor.subtitle.color])
		
		guard self.episode.intro.contains("<") else {
			let content = NSAttributedString.init(string: self.episode.intro+"\n", attributes: [NSAttributedString.Key.font : pfont(14), NSAttributedString.Key.foregroundColor: CommonColor.content.color])
			self.desTextView.attributedText = title + author + content
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
			self.desTextView.attributedText = title + author + attrStr;
		}catch _ as NSError {
			let content = NSAttributedString.init(string: self.episode.intro+"\n", attributes: [NSAttributedString.Key.font : pfont(14), NSAttributedString.Key.foregroundColor: CommonColor.content.color])
			self.desTextView.attributedText = title + author + content
		}

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		FMToolBar.shared.shrink()
    }
	
}
