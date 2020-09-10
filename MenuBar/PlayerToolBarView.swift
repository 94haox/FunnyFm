//
//  PlayerToolBarView.swift
//  MenuBar
//
//  Created by Tao on 2020/9/2.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct PlayerToolBarView: View {
    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 12){
                    Image(systemName: "shuffle")
                    Image(systemName: "repeat")
                }
                .font(.title2)
                .padding(.leading, 16)
                Spacer()
                HStack(spacing: 18){
                    Image(systemName: "gobackward.10")
                        .foregroundColor(Color.gray)
                    Image(systemName: "play.fill")
                    Image(systemName: "goforward.15")
                        .foregroundColor(Color.gray)
                }
                .font(.title2)
                Spacer()
                HStack {
                    Text("72%")
                    Image(systemName: "speaker.3.fill")
                        .font(.title2)
                }
                .padding(.trailing, 16)
            }
        }
    }
}

struct PlayerToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerToolBarView()
    }
}
