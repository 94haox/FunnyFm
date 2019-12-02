//
//  NoteViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/2.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class NoteViewModel{

	
	func createNote(params: [String: Any], _ success:@escaping()->Void){
		
		FmHttp<Note>().requestForSingle(NoteAPI.createNotes(params), false, { (_) in
			success()
		}) { (error) in
			if error.isSome {
				SwiftNotice.showText(error!)
			}
		}
	}
	
	func getNotes(episode: Episode){
		
	}
	

}
