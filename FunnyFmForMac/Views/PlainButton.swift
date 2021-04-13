//
//  PlainButton.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/12.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct PlainButton<Label>: View where Label: View {
    
    private let label: Label
    
    private let action: (() -> Void)
    
    init(label: () -> Label,
         action: @escaping () -> Void) {
        self.label = label()
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Spacer()
            HStack {
                VStack {
                    Spacer()
                    label
                    Spacer()
                }
            }
            Spacer()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

