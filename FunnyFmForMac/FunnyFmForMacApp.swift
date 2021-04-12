//
//  FunnyFmForMacApp.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

@main
struct FunnyFmForMacApp: App {
    let persistenceController = PersistenceController.shared
    
    @ObservedObject var user: UserCenter = UserCenter.shared
    
    @ObservedObject var playState: PlayState = PlayState.shared
    
    @StateObject private var uiState = UIState.shared

    init() {
        print("create app")
    }
    
    var body: some Scene {
        WindowGroup {
            if user.isLogin {
                ZStack {
                    NavigationView {
                        SlideBar()
                            .environmentObject(uiState)
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        ProgressView()
                    }
                    .padding(.bottom, 80)
                    .background(Color.white)
                    VStack {
                        Spacer()
                        PlayBarView()
                            .background(Color.white)
                            .frame(maxWidth: .infinity, minHeight: 80, idealHeight: 80, maxHeight: 80)
                            .environmentObject(playState)
                    }.shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                .environmentObject(uiState)
                .frame(minWidth: 1000, idealWidth: 1000, maxWidth: 1000, minHeight: 700, idealHeight: 700, maxHeight: 700)
            } else {
                LoginView()
                    .frame(width: 500, height: 400, alignment: .center)
                    .background(Color.white)
            }
        }
    }
}
