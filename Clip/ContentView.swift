//
//  ContentView.swift
//  Clip
//
//  Created by 吴涛 on 2020/8/18.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import StoreKit

//https://f.video.weibocdn.com/C3LWATTBlx07FUNNuH8k01041200w85c0E010.mp4?label=mp4_1080p&template=1920x1080.25.0&trans_finger=0bde055d9aa01b9f6bc04ccac8f0b471&media_id=4541878901866502&tp=8x8A3El:YTkl0eM8&us=0&ori=1&bf=4&ot=h&ps=3lckmu&uid=3ZoTIp&ab=966-g1&Expires=1598498733&ssig=y9xfqAgsOk&KID=unistore,video

struct ContentView: View {
    
    @EnvironmentObject var channel: Channel
    
    @State var url: URL? = URL.init(string: "https://f.video.weibocdn.com/C3LWATTBlx07FUNNuH8k01041200w85c0E010.mp4?label=mp4_1080p&template=1920x1080.25.0&trans_finger=0bde055d9aa01b9f6bc04ccac8f0b471&media_id=4541878901866502&tp=8x8A3El:YTkl0eM8&us=0&ori=1&bf=4&ot=h&ps=3lckmu&uid=3ZoTIp&ab=966-g1&Expires=1598513157&ssig=FrMTJ2L5GH&KID=unistore,video")
    
    @State var height: CGFloat? = 200
    
    @State var width: CGFloat? = 300
    
    @State var isShow: Bool = false
    
    @State private var overLayer: SKOverlayView? = SKOverlayView()
    
    fileprivate func item() -> HStack<TupleView<(VStack<TupleView<(Text, Text)>>, Spacer, VStack<TupleView<(Text, Text)>>)>> {
        return HStack {
            VStack(alignment: .leading){
                Text("sssss")
                Text("ssssssssssssssssssssss")
            }
            Spacer()
            VStack(alignment: .leading){
                Text("sssss")
                Text("ssssssssssssssssssssss")
            }
        }
        
    }
    
    var body: some View {
        ZStack {
            AVPlayerView(videoURL: $url, height: $height, width: $width)
                .padding(.top, 500)
            VStack(alignment: .leading) {
                VStack {
                    ZStack {
                        HStack {
                            Spacer()
                        }
                        .frame(width: 415, height: 100)
                        .background(Color.black)
                        HStack (spacing: 16){
                            Image.init("logo-white")
                            Text("生而出色， 简而不凡")
                                .font(.headline)
                                .foregroundColor(Color.white)
                            Spacer()
                        }.padding(.horizontal, 12)
                    }
                    .padding(.bottom, 32)
//                    Text("")
//                        .font(.largeTitle)
//                        .bold()
                }
                .padding(.bottom, 24)
                VStack {
                    HStack {
                        HStack {
                            Image("product")
                                .resizable()
                        }
                        .frame(width: 70, height: 50)
                        .padding(.trailing, 12)
                        Text("包装清单")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.bottom, 12)
                    VStack(alignment: .leading) {
                        item()
                        item()
                        item()
                        item()
                        item()
                    }
                    .redacted(reason: .placeholder)
                }
                .padding(.horizontal, 16)
                HStack{
                    Spacer()
                    Button.init(action: {
//                        isShow = true
                        let view = SKOverlayViewSingle()
                        view.present()
                    }, label: {
                        HStack {
                            Text("立即绑定")
                                .foregroundColor(.white)
                        }
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .clipShape(Capsule())
                    })
                    Spacer()
                }.padding(.top, 32)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
