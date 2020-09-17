//
//  NoteDetailViewController.swift
//  ComponentList
//
//  Created by Duke on 2019/12/3.
//  Copyright © 2019 duke. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
	@IBOutlet weak var delBtn: UIButton!
	@IBOutlet weak var timeLB: UILabel!
	@IBOutlet weak var dateLB: UILabel!
	@IBOutlet weak var typeLB: UILabel!
	@IBOutlet weak var contentLB: UILabel!
	var note: Note?
	var viewModel: NoteViewModel = NoteViewModel()
	var deleteCallback: ((String)->Void)?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.timeLB.text = Date.formatIntervalToMM(note!.noteMoment)
		self.dateLB.text = note!.createTime
		self.contentLB.text = note!.noteDesc
        switch note!.noteType {
			case 1:
				self.typeLB.text = "✍🏻✍🏻✍🏻"
			case 2:
				self.typeLB.text = "👏🏻👏🏻👏🏻"
			case 3:
				self.typeLB.text = "🤔🤔🤔"
			default:
			break
		}
		
		if UserCenter.shared.userId == note?.userId {
			self.delBtn.isHidden = false
		}
        self.view.backgroundColor = CommonColor.background.color
    }


	@IBAction func deleteAction(_ sender: Any) {
		if self.note.isNone {
			SwiftNotice.showText("参数v错误")
			return;
		}
        Hud.shared.show(on: self.view)
		var params = [String : Any]()
		params["note_id"] = self.note?.noteId
		self.viewModel.deletNotes(params: params) { [weak self] in
			if self.isNone {
				return
			}
			if self!.deleteCallback.isSome {
				self!.deleteCallback!(self!.note!.noteId)
			}
			self?.dismiss(animated: true, completion: nil)
		}
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
