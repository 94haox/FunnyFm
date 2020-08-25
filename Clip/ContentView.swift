//
//  ContentView.swift
//  Clip
//
//  Created by 吴涛 on 2020/8/18.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var channel: Channel
    
    var body: some View {
        Text("来自： \(channel.url)")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
