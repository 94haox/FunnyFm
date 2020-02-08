//
//  NoteEditViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/2.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import AutoInch
import DynamicColor
import OfficeUIFabric


class NoteEditViewController: UIViewController {

	@IBOutlet weak var limitTextView: GFLimitTextView!
	@IBOutlet weak var publicBtn: UIButton!
	@IBOutlet weak var disAgreeBtn: UIButton!
	@IBOutlet weak var agreeBtn: UIButton!
	@IBOutlet weak var noteBtn: UIButton!
	var viewModel: NoteViewModel = NoteViewModel()
	var selectedBtn: UIButton?
	var episode: Episode?
	
	override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CommonColor.white.color
		self.changeManner(self.noteBtn)
		self.dw_addTouchEndEdit()
		self.limitTextView.limitTextNum = 100;
		self.limitTextView.placeText = "写点什么吧🤳🏻"
    }
	
	@IBAction func confirmAction(_ sender: Any) {
		self.confirmSaveAction()
	}
	
	func confirmSaveAction(){
		if self.episode.isNone{
			return
		}
		
		if self.limitTextView.isLimit {
			self.limitTextView.alertAnimation()
			return
		}
		
		if FMPlayerManager.shared.currentTime < 10 {
			SwiftNotice.showText("您似乎还没开始听？🤭")
			return
		}
		
		if self.limitTextView.textView.text.length() < 1 {
			SwiftNotice.showText("写点什么吧😉")
			return;
		}
		
		var params = [String: Any]()
		params["track_url"] = self.episode!.trackUrl
		params["note_moment"] = FMPlayerManager.shared.currentTime-5
		params["note_desc"] = self.limitTextView.textView.text
		params["note_type"] = self.selectedBtn!.tag - 1000
		params["is_private"] = self.publicBtn.isSelected
		MSHUD.shared.show(from: self)
		self.viewModel.createNote(params: params) {
			SwiftNotice.showText("添加成功🥳")
			self.dismiss(animated: true, completion: nil)
		}
	}

	
	@IBAction func changePrivate(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
	}
	@IBAction func changeManner(_ sender: UIButton) {
		self.limitTextView.textView.endEditing(true)
		if self.selectedBtn.isSome {
			self.selectedBtn!.isSelected = false
			self.selectedBtn!.backgroundColor = UIColor.black
		}
		self.selectedBtn = sender
		self.selectedBtn!.isSelected = true
		self.selectedBtn!.backgroundColor = CommonColor.mainRed.color
	}


}
