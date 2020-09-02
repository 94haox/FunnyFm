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
                HStack {
                    HStack {
                        Image(systemName: "shuffle")
                            .resizable()
                    }
                    
                    HStack {
                        Image(systemName: "repeat")
                            .resizable()
                    }
                }
                Spacer()
                HStack {
                    HStack {
                        Image(systemName: "gobackward.10")
                            .resizable()
                    }
                    HStack {
                        Image(systemName: "play.fill")
                            .resizable()
                    }
                    HStack {
                        Image(systemName: "goforward.15")
                            .resizable()
                    }
                }
                Spacer()
                HStack {
                    Text("72%")
                    HStack {
                        Image(systemName: "speaker.3.fill")
                            .resizable()
                    }
                }
            }
        }
    }
}

struct PlayerToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerToolBarView()
    }
}
