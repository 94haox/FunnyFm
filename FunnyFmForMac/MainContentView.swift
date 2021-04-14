//
//  ContentView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI
import CoreData
import AuthenticationServices

struct MainContentView: View {
    
    let channel: UIState.DefaultChannels

    var body: some View {
        VStack {
            switch channel {
                case .nearest:
                    DashboradView()
                case .subscribe:
                    SubscribesView()
                case .discover:
                    DiscoverView()
            }
        }
        .navigationTitle(channel.rawValue)
    }
}
