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
             Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                LazyHGrid(rows: columns) {
                    ForEach(viewModel.podcasts, id: \.self) { podcast in
                        SubPodcastView(podcast: podcast, selected: $viewModel.selectionPodcast)
                    }
                }
                .padding(.all, 12)
                .onAppear {
                    viewModel.fetchSubscribes()
                }
            }
            if viewModel.selectionPodcast.isSome {
                HStack {
                    Spacer()
                    PodcastInfoView(podcast: $viewModel.selectionPodcast)
                        .frame(minWidth: 300, idealWidth: 300, maxWidth: 400)
                }
                .transition(AnyTransition.move(edge: .trailing))
            }
        }
        .navigationTitle(UIState.DefaultChannels.subscribe.rawValue)
        .navigationSubtitle("\(viewModel.podcasts.count)")
    }
}
