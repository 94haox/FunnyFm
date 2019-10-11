//
//  GeneralViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2019/10/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class GeneralViewModel: BaseViewModel {
	
	var messageList: [Message] = []
	
	func getAllMessageList(){
		FmHttp<Message>().requestForArray(GeneralAPI.getAllMessage, { (messagelist) in
			if messagelist.isSome{
				self.messageList = messagelist!
			}
			self.delegate?.viewModelDidGetDataSuccess()
		}) { (error) in
			self.delegate?.viewModelDidGetDataFailture(msg: error)
		}
	}

}
