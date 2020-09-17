//
//  EpisodeInfoView.swift
//  Clips
//
//  Created by 吴涛 on 2020/9/17.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct EpisodeInfoView: View {
    
    var query: String?
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack {
            
        }
        .onAppear(perform: {
            
        })
    }
}

struct EpisodeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeInfoView(query: "id=123")
    }
}
