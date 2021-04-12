//
//  SlideItemView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct SlideItemView: View {
    
    private let title: String
    
    private let iconName: String
    
    init(title: String,
         iconName: String) {
        self.iconName = iconName
        self.title = title
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: iconName)
                    .padding(.leading, 12)
                Text(title)
                    .padding(.vertical, 2)
                Spacer()
            }
            Spacer()
        }
        .cornerRadius(5)
    }
}
