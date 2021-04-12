//
//  EpisodeView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct EpisodeView: View {
    
    @Binding var show: Bool
    
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(viewModel.selectedEpisode?.title ?? "sssssss")
                Spacer()
            }
            Spacer()
        }
        .frame(width: 100)
        .background(Color.white)
        .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(Animation.easeInOut(duration: 2)) {
                    self.show = false
                }
            }
       })
    }
}
