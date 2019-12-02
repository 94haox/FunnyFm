//
//  UserViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/13.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class UserViewModel: BaseViewModel {
	
    func addFavour(_ episodeId: String){
		FmHttp<User>().requestForSingle(UserAPI.addFavour(episodeId), { (_) in
            self.delegate?.viewModelDidGetDataSuccess()
        }) { (msg) in
            self.delegate?.viewModelDidGetDataFailture(msg: msg)
        }
    }
    
    func deleteFavour(_ episodeId: String){
		FmHttp<User>().requestForSingle(UserAPI.disFavour(episodeId), { (_) in
            self.delegate?.viewModelDidGetDataSuccess()
        }) { (msg) in
            self.delegate?.viewModelDidGetDataFailture(msg: msg)
        }
    }
    
    func addSubscribe(_ podId: String){
		FmHttp<User>().requestForSingle(UserAPI.addSubscribe(podId), { (_) in
            self.delegate?.viewModelDidGetDataSuccess()
        }) { (msg) in
            self.delegate?.viewModelDidGetDataFailture(msg: msg)
        }
    }
    
    func cancelSubscribe(_ podId: String){
		FmHttp<User>().requestForSingle(UserAPI.disSubscribe(podId), { (_) in
            self.delegate?.viewModelDidGetDataSuccess()
        }) { (msg) in
            self.delegate?.viewModelDidGetDataFailture(msg: msg)
        }
    }
	
	func getUserAllFavors(){
		FmHttp<Favor>().requestForArray(UserAPI.getFavourList, { (favorList) in
			self.delegate?.viewModelDidGetDataSuccess()
		}) { (msg) in
			self.delegate?.viewModelDidGetDataFailture(msg: msg)
		}
	}

    
}
