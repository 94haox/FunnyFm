//
//  PodcastInfoView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/13.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI


struct PodcastInfoView: View {
    @Binding var podcast: GPodcast?
    
    @State private var attributeContent: NSAttributedString?
    
    @State private var normalContent: String?
    
    @State var width: CGFloat = 0
    
    @State private var items: [Episode]?
    
    @State var epSelection: String? {
        didSet {
            guard let eps = items,
                  let seletion = epSelection,
                  let ep = eps.filter({$0.id == seletion}).first else {
                return
            }
            PlayState.shared.config(ep)
        }
    }
    
    @State var segmentSelection: Int = 0

    func fetchEpisodes() {
        guard let podcastUrl = podcast?.rss_url else {
            return
        }
        DispatchQueue.global().async {
            let eps = CDEpisode.fetchAll(with: podcastUrl)
            DispatchQueue.main.async {
                items = eps
            }
        }
    }
    
    var body: some View {
        if podcast == nil {
            Text("")
        } else {
            VStack {
                HStack {
                    FFImageView(urlString: podcast!.artwork_url)
                        .frame(width: 100, height: 100)
                        .cornerRadius(15)
                        .padding(.horizontal, 16)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(podcast!.track_name)
                                .font(.title)
                            Spacer()
                        }
                        if podcast!.author.isSome {
                            HStack(spacing: 10) {
                                Image(systemName: "person.2.circle")
                                Text(podcast!.author!)
                            }
                            .font(.body)
                            .foregroundColor(.gray)
                        }
                        HStack(spacing: 10) {
                            Image(systemName: "link.circle")
                            Text("\(items?.count ?? 0)")
                        }
                        .font(.body)
                        .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .frame(idealHeight: 100, maxHeight: 100)
                .padding(.top, 16)
                HStack {
                    Spacer()
                    Picker("", selection: $segmentSelection) {
                        Text("列表")
                            .tag(0)
                        Text("简介")
                            .tag(1)
                    }
                    .frame(width: 200)
                    .pickerStyle(SegmentedPickerStyle())
                    Spacer()
                }
                
                VStack {
                    if segmentSelection == 0 {
                        if items?.count ?? 0 > 0 {
                            List {
                                ForEach(items ?? []) { item in
                                    EpisodeItemView(episode: item, selection: $epSelection)
                                        .tag(item.id)
                                        .frame(height: 60)
                                }
                            }
                        } else {
                            VStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    } else {
                        HStack {
                            if attributeContent.isNone {
                                Text(normalContent ?? "主播尚未添加简介")
                                    .padding(.all, 12)
                            } else {
                                ScrollView {
                                    AttributedText(attributeContent!)
                                        .padding(.all, 12)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
            .onChange(of: self.podcast, perform: { (item) in
                items = nil
                self.parserAttribute()
                self.fetchEpisodes()
            })
            .onAppear {
                self.parserAttribute()
                self.fetchEpisodes()
            }
            .toolbar(content: {
                Spacer()
                PlainButton {
                    HStack {
                        Image(systemName: "person.crop.circle.fill.badge.xmark")
                        Text("取消订阅")
                    }
                } action: {
                    podcast = nil
                }
                .frame(width: 100)
            })
            .background(Color.white)
            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 0)
        }
    }
}

extension PodcastInfoView {
    
    func parserAttribute() {
        attributeContent = nil
        guard let podcast = self.podcast,
              let desc = podcast.desc else {
            normalContent = nil
            return
        }
        attributeContent = nil
        normalContent = nil
        do {
            let srtData = desc.data(using: String.Encoding.unicode, allowLossyConversion: true)!
            attributeContent = try NSMutableAttributedString(data: srtData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            normalContent = desc
        }
        
        
    }
    
    
}
