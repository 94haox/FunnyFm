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
        List (selection: $viewModel.selection){
            ForEach(viewModel.nearestEpisodes) { item in
                EpisodeItemView(ep: item)
                    .frame(height: 60)
                    .tag(item.trackUrl)
                    .onTapGesture {
                        showInfo = true
                    }
            }
        }
        .listStyle(InsetListStyle())
        .onAppear {
            viewModel.fetchEpisodes()
        }
    }
}
