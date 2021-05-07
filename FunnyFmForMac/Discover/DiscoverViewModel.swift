//
//  DiscoverViewModel.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import Foundation

enum Category {
    case Arts
    case Business
    case Comedy
    case Education
    case KF //Kids & Family
    case Music
    case RS //Religion & Spirituality
    case SC // Society & Culture
    case Tech // Technology
    
    var name: String {
        switch self {
            case .Arts:
                return "Arts"
            case .Business:
                return "Business"
            case .Comedy:
                return "Comedy"
            case .Education:
                return "Education"
            case .KF:
                return "Kids & Family"
            case .Music:
                return "Music"
            case .RS:
                return "Religion & Spirituality"
            case .SC:
                return "Society & Culture"
            case .Tech:
                return "Technology"
        }
    }
    
    var icon: String {
        switch self {
            case .Arts:
                return "art"
            case .Business:
                return "business"
            case .Comedy:
                return "comedy"
            case .Education:
                return "edu"
            case .KF:
                return "kids"
            case .Music:
                return "music-cate"
            case .RS:
                return "pray"
            case .SC:
                return "society"
            case .Tech:
                return "tech"
        }
    }
    
    var topicId: String {
        switch self {
            case .Arts:
                return "1301"
            case .Business:
                return "1321"
            case .Comedy:
                return "1303"
            case .Education:
                return "1304"
            case .KF:
                return "1305"
            case .Music:
                return "1310"
            case .RS:
                return "1314"
            case .SC:
                return "1324"
            case .Tech:
                return "1318"
        }
    }
    
    static var all: [Category] {
        return [
            .Arts,
            .Business,
            .Comedy,
            .Education,
            .KF,
            .Music,
            .RS,
            .SC,
            .Tech
        ]
    }
    
}

class DiscoverViewModel: ObservableObject {
 
    @Published var status: FetchStatus = .done
    
    var categories: [Category] = Category.all

    public func fetchDiscoverData() {
        
    }
    
}
