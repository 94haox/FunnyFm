//
//  PlainButton.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/12.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct PlainButton: View {
    
    private let text: String
    
    private let action: (() -> Void)
    
    init(text: String,
         action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Spacer()
            HStack {
                VStack {
                    Spacer()
                    Text(text)
                    Spacer()
                }
            }
            Spacer()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

