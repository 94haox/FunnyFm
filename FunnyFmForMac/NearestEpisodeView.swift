//
//  NearestEpisodeView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/12.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct NearestEpisodeView: View, Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.viewModel.nearestEpisodes.count == rhs.viewModel.nearestEpisodes.count
    }
    
    @ObservedObject var viewModel: DashboardViewModel
    
    @Binding var showInfo: Bool
    
    var body: some View {
        VStack (alignment: .leading) {
            
            List () {
                if viewModel.todayEpisodes.count > 0 {
                    Text("今日更新")
                        .bold()
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: Array(repeating: .init(.flexible()), count: viewModel.todayEpisodes.count < 4 ? viewModel.todayEpisodes.count : 4)) {
                            ForEach(viewModel.todayEpisodes) { item in
                                EpisodeGridView(episode: item, selection: $viewModel.selection)
                                    .frame(minHeight: 60)
                            }
                        }
                    }
                    .frame(minHeight: viewModel.todayEpisodes.count < 4 ? CGFloat((60 * viewModel.todayEpisodes.count)) : 240 )
                }
                Text("最近更新")
                    .bold()
                    .padding(.top, 32)
                ForEach(viewModel.nearestEpisodes) { item in
                    EpisodeItemView(episode: item, selection: $viewModel.selection)
                        .frame(minHeight: 60)
                        .tag(item.id)
                }
            }
            .listStyle(InsetListStyle())
        }
        .onAppear {
            viewModel.fetchEpisodes()
        }
    }
}
