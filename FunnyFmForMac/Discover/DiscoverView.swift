//
//  DiscoverView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        Text("Discover")
            .navigationTitle(UIState.DefaultChannels.discover.rawValue)
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
