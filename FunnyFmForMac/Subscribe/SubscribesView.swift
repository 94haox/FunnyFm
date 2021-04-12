//
//  SubscribesView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct SubscribesView: View {
    
    @ObservedObject private var viewModel = SubscribeViewModel()
    var columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach((0...79), id: \.self) {
                    let codepoint = $0 + 0x1f600
                    let codepointString = String(format: "%02X", codepoint)
                    Text("\(codepointString)")
                    let emoji = String(Character(UnicodeScalar(codepoint)!))
                    Text("\(emoji)")
                }
            }
            .font(.largeTitle)
            .onAppear {
                viewModel.fetchSubscribes()
            }
        }
        .navigationTitle(UIState.DefaultChannels.subscribe.rawValue)
    }
}
