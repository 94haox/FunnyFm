//
//  PlaybarInfo.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/11.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct PlaybarInfo: View {
    
    let episode: Episode?
    
    var body: some View {
        HStack {
            if episode.isSome {
                FFImageView(urlString: episode!.coverUrl)
                    .frame(width: 40, height: 40)
                    .cornerRadius(5)
                VStack(alignment: .leading) {
                    HStack {
                        Text(episode!.title)
                            .font(.headline)
                            .padding(.bottom, 4)
                        Spacer()
                    }.frame(maxWidth: 200)
                    Text(episode!.author)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } else {
                Image("logo-white")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                VStack(alignment: .leading) {
                    Text("发掘自己的快乐")
                        .font(.headline)
                        .padding(.bottom, 4)
                    Text("趣播客")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
