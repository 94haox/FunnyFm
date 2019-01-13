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
        FmHttp<User>().requestForSingle(UserAPI.addFavour(episodeId), success: { (_) in
            self.delegate?.viewModelDidGetDataSuccess()
        }) { (msg) in
            self.delegate?.viewModelDidGetDataFailture(msg: msg)
        }
    }
    
    func deleteFavour(_ episodeId: String){
        FmHttp<User>().requestForSingle(UserAPI.disFavour(episodeId), success: { (_) in
            self.delegate?.viewModelDidGetDataSuccess()
        }) { (msg) in
            self.delegate?.viewModelDidGetDataFailture(msg: msg)
        }
    }

    
}
