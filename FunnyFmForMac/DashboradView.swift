//
//  DashboradView.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI
import CoreData

struct DashboradView: View {
    
    @EnvironmentObject private var uiState: UIState
    
    @ObservedObject private var viewModel: DashboardViewModel = DashboardViewModel()
    
    @State public var showEpisodeInfo: Bool = false
    
    @State public private(set) var selectedEpisode: Episode?
    
    var body: some View {
        NearestEpisodeView(viewModel: viewModel, showInfo: $showEpisodeInfo)
            .equatable()
            .padding(.leading, 12)
            .navigationTitle(UIState.DefaultChannels.nearest.rawValue)
    }
}

struct DashBoradView_Previews: PreviewProvider {
    static var previews: some View {
        DashboradView()
    }
}
