//
//  NowSmallView.swift
//  FunnyFm
//
//  Created by Tao on 2020/10/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct NowSmallView: View {
    
    var entry: Provider.Entry
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                VStack (alignment: .leading){
                    HStack {
                        if entry.image == nil || entry.title == nil {
                            Image("logo-white")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .cornerRadius(15)
                        }else{
                            Image(uiImage: entry.image!)
                                .resizable()
                                .frame(width: 45, height: 45)
                                .cornerRadius(15)
                        }
                        Spacer()
                        PlayStateDotView(entry: entry)
                    }
                    if entry.title == nil {
                        Text("xxxxx")
                            .redacted(reason: .placeholder)
                    }else{
                        Text(entry.isPlay ? "正在播放":"等待播放")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                            .padding(.vertical, 4)
                    }
                    if entry.title == nil {
                        Text("xxxxxxxxxxxx")
                            .redacted(reason: .placeholder)
                    }else{
                        Text(entry.title!)
                            .font(.footnote)
                            .bold()
                            .lineLimit(2)
                    }
                }
            }
        }
        .widgetURL(URL(string: entry.widgetUrl))
        .padding(.all, 12)
    }
}

