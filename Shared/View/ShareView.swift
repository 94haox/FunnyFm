//
//  ShareView.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/5/7.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShareView: View {
    
    var podcast: iTunsPod
    
    @State var qrImage: UIImage?
    
    var body: some View {
        VStack {
            HStack {
                FFImageView(urlString: podcast.artworkUrl600)
                    .frame(width: 100, height: 100, alignment: .center)
                    .cornerRadius(5)
                VStack {
                    Text(podcast.trackName)
                    Text(podcast.podAuthor)
                    Text(podcast.trackCount)
                }
            }
            .padding(.bottom, 32.auto())
            
            Spacer()
            
            HStack {
                Image("logo-white")
                    .frame(width: 60, height: 60)
                VStack {
                    Text("趣播客")
                    Text("主动发掘听的乐趣")
                }
                Spacer()
                Image(uiImage: qrImage!)
                    .frame(width: 60, height: 60)
            }
            .padding()
            .background(Color.init(R.color.content()!))
            .cornerRadius(5)
        }
    }
}
