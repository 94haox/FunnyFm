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
    
    @State var animated: Bool = false
    
    @Binding var shown: Bool
    
    @Binding var selection: String?
    
    @State private var attributeContent: NSAttributedString?
    
    @State private var normalContent: String?
    
    private let marginLeading: CGFloat = 18
    
    var podcast: GPodcast?
    
    var episode: Episode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    FFImageView(urlString: episode.coverUrl)
                        .frame(width: 100, height: 100, alignment: .center)
                        .cornerRadius(5)
                    VStack (spacing: 10){
                        HStack {
                            EpisodePlayControl(episode: episode, shown: $show, selection: $selection)
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            VStack (alignment: .leading, spacing: 5){
                                Text(Date.formatIntervalToString(NSInteger(episode.duration)))
                                Text(episode.pubDate)
                            }
                            Spacer()
                        }
                        .font(.callout)
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "xmark.circle")
                            .font(.title)
                            .foregroundColor(.accentColor)
                            .onTapGesture {
                                show = false
                            }
                        Spacer()
                    }
                }
                .frame(height: 100)
                .padding(.all, marginLeading)
                HStack {
                    Text(episode.title)
                        .font(.largeTitle)
                    Spacer()
                }
                .padding(.all, marginLeading)
                if podcast.isSome {
                    HStack {
                        HStack {
                            PodcastShortView(podcast: podcast!)
                                .padding(.horizontal, marginLeading)
                            Spacer()
                        }
                        .frame(width: 250, height: 70)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                        Spacer()
                    }
                    .padding(.horizontal, marginLeading)

                }
                HStack {
                    if attributeContent.isNone {
                        Text(normalContent ?? "主播尚未添加单集简介")
                            .padding(.all, marginLeading)
                    } else {
                        ScrollView {
                            AttributedText(attributeContent!)
                                .padding(.all, marginLeading)
                        }
                    }
                }
                Spacer()

            }
        }
        .background(Color.white)
        .onAppear {
            self.parserAttribute()
        }
    }
}

struct PodcastShortView: View {
    
    let podcast: GPodcast
    
    var body: some View {
        HStack {
            FFImageView(urlString: podcast.artwork_url)
                .frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(5)
                .padding(.vertical, 12)
            VStack (alignment: .leading){
                Text(podcast.track_name)
                    .padding(.bottom, 2)
                    .font(.callout)
                Text(podcast.author ?? podcast.track_name)
                    .font(.caption)
            }
            .foregroundColor(.gray)
        }
    }
    
}

extension EpisodeView {
    
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
