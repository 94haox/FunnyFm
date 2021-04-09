//
//  Endpoint.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation

public enum Endpoint {
    // MARK: Podcasts
    case getPodList
    case searchPod(String)
    case parserRss(Dictionary<String, String>)
    case registerPod(Dictionary<String, String>)
    case getPodcastPrev(String)
    
    // MARK: Chapters
    case getHomeChapterList
    case getChapterList(Int,Int)
    
    // MARK: User
    case login([String: Any])
    case register([String: Any])
    case addFavour(String)
    case disFavour(String)
    case addSubscribe(String)
    case disSubscribe(String)
    case getFavourList
    case getSubscribeList
    
    // MARK: General
    case getAllMessage
    case getVersion
    case getRecommends
    
    // MARK: Note
    case getNotes(String)
    case createNotes([String: Any])
    case deleteNote([String: Any])
    
    func path() -> String {
        switch self {
        
            case .getPodList:
                return kGetPodListurl
            case .searchPod(_):
                return kSearchPodUrl
            case .parserRss(_):
                return kParserRssUrl
            case .registerPod(_):
                return kRegisterPodUrl
            case .getPodcastPrev(_):
                return kPodcastDetailUrl
            case .getHomeChapterList:
                return kGetHomeChapterListurl
            case .getChapterList(_, _):
                return kGetChapterListurl
            case .login(_):
                return kLoginUrl
            case .register(_):
                return kRegisterUrl
            case .addFavour(_):
                return kAddFavour
            case .disFavour(_):
                return kDissFavour
            case .addSubscribe(_):
                return kAddSubscribe
            case .disSubscribe(_):
                return kDisSubscribe
            case .getFavourList:
                return kFavourList
            case .getSubscribeList:
                return kSubscribeList
            case .getAllMessage:
                return kGetAllMessage
            case .getVersion:
                return kGetVersion
            case .getRecommends:
                return kGetRecommends
            case .getNotes(_):
                return kGetNotes
            case .createNotes(_):
                return kCreateNotes
            case .deleteNote(_):
                return kDeleteNote
        }
    }
}
