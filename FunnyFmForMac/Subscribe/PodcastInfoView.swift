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
        items = CDEpisode.fetchAll(with: podcastUrl)
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
                HStack {
                    Picker("", selection: $segmentSelection) {
                        Text("列表")
                            .tag(0)
                        Text("简介")
                            .tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                VStack {
                    if segmentSelection == 0 {
                        List {
                            ForEach(items ?? []) { item in
                                EpisodeItemView(episode: item, selection: $epSelection)
                                    .tag(item.id)
                                    .frame(height: 60)
                            }
                        }
                    } else {
                        Spacer()
                        HStack {
                            Text(podcast?.desc ?? "主播尚未添加简介")
                                .padding(.all, 12)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .onChange(of: self.podcast, perform: { (item) in
                self.fetchEpisodes()
            })
            .onAppear {
                self.fetchEpisodes()
            }
            .background(Color.white)
            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 0)
        }
    }
}
