//
//  NoteViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/2.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class NoteViewModel{

	var notelist: [Note] = [Note]()
	
	func createNote(params: [String: Any], _ success:@escaping()->Void){
		
		FmHttp<Note>().requestForSingle(NoteAPI.createNotes(params), false, { (_) in
			success()
		}) { (error) in
			if error.isSome {
				SwiftNotice.showText(error!)
			}
		}
	}
	
	func getNotes(episode: Episode, success:@escaping()->Void){
		FmHttp<Note>().requestForArray(NoteAPI.getNotes(episode.trackUrl), { (list) in
			if list.isSome {
				self.notelist = list!
			}
			success()
		}) { (error) in
			if error.isSome {
				SwiftNotice.showText(error!)
			}
		}
	}
	
	func deletNotes(params: [String: Any], success:@escaping()->Void){
		FmHttp<Note>().requestForSingle(NoteAPI.deleteNote(params), false, { (_) in
			success()
		}) { (error) in
			if error.isSome {
				SwiftNotice.showText(error!)
			}
		}
	}
	

}
