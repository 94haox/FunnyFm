//
//  DiscoverView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct DiscoverView: View {
    @State private var searchText: String = ""
    
    @State private var isFocused = false
    
    @State private var categorySelection: String?
    
    var body: some View {
        VStack() {
            HStack {
                DiscoverCategoriesView(selection: $categorySelection)
                Spacer()
            }
            ProgressView()
        }
        .toolbar(content: {
            ToolbarItemGroup {
                Spacer()
                TextField("Search anything", text: $searchText) { editing in
                    isFocused = editing
                } onCommit: {
                    
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            }
        })
        .navigationTitle(UIState.DefaultChannels.discover.rawValue)
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
