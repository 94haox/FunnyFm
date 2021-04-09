//
//  PlayBarView.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct PlayBarView: View {
    var body: some View {
        HStack {
            Image(systemName: "flame.fill")
                .font(.largeTitle)
                .padding(.horizontal, 32)
            VStack(alignment: .leading) {
                Text("打工人，打工魂")
                    .font(.headline)
                    .padding(.bottom, 12)
                Text("屁事没干")
                    .font(.callout)
                    .foregroundColor(Color.gray)
            }
            .padding(.trailing, 32)
            HStack(spacing: 16) {
                Image(systemName: "gobackward.15")
                    .font(.title3)
                Image(systemName: "play.circle.fill")
                    .font(.largeTitle)
                Image(systemName: "goforward.30")
                    .font(.title3)
            }
            Spacer()
            HStack {
                Image(systemName: "circle.grid.2x2")
                    .font(.largeTitle)
            }
            .padding(.horizontal, 32)
        }
    }
}

struct PlayBarView_Previews: PreviewProvider {
    static var previews: some View {
        PlayBarView()
    }
}
