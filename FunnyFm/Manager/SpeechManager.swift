//
//  SpeechManager.swift
//  ComponentList
//
//  Created by Duke on 2019/11/19.
//  Copyright © 2019 duke. All rights reserved.
//

import UIKit
import Speech


class SpeechManager: NSObject {
	
	static let shared = SpeechManager()
	
	var myRecognizer: SFSpeechRecognizer?
	
	func recognizeFile(url: URL, local:String?, startTime: Int, complete:@escaping(String?, String?)->Void) {
		SFSpeechRecognizer.requestAuthorization { (status) in
			if status == .authorized {
				self.recognize(url: url, local: local, startTime: startTime, complete: complete)
				return
			}
			
			SwiftNotice.showText("获取授权失败，请到设置中打开授权", autoClear: true, autoClearTime: 2)
		}
		
		
	}
	
	func recognize(url: URL, local:String?, startTime: Int, complete:@escaping(String?, String?)->Void) {
		let asset = AVURLAsset.init(url: url, options: nil)
		let assetTime = asset.duration
		let duration = Int(CMTimeGetSeconds(assetTime).rounded())
		var endTime = startTime + 59
		if endTime > duration {
			endTime = duration
		}
		
		
		CropAudioManager.audioCrop(url, startTime:startTime , endTime:endTime, name: "\(Date())_crop") { (isSuccessed, filepath) in
			
			if !isSuccessed {
				return
			}
			
			var localString = "en_US"
			if let string = local {
				localString = string
			}
	
			self.speechToText(filepath: filepath, locale: localString) { (isSuccessed,text) in
				complete(text, filepath)
			};
		}
	}
	

	func speechToText(filepath: String, locale: String,complete: @escaping(Bool,String?) -> Void){
		
		if self.myRecognizer.isNone {
			self.myRecognizer = SFSpeechRecognizer.init(locale: Locale.init(identifier: locale))
		}
		
		guard self.myRecognizer.isSome else {
			complete(false,nil)
		   return
		}
		if !self.myRecognizer!.isAvailable {
			complete(false,nil)
		   return
		}

		let cropUrl = URL.init(fileURLWithPath: filepath)
		let request = SFSpeechURLRecognitionRequest(url: cropUrl)
		self.myRecognizer!.recognitionTask(with: request) { (result, error) in
		   guard let result = result else {
				print("error----\(String(describing: error))")
				complete(false,nil)
			  	return
		   }
		   if result.isFinal {
				complete(true,result.bestTranscription.formattedString)
		   }
		}

		
	}
	
	
}
