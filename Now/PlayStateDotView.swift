//
//  PlayStateDotView.swift
//  FunnyFm
//
//  Created by Tao on 2020/10/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct PlayStateDotView: View {
	
	var entry: Provider.Entry
	
    var body: some View {
		ZStack {
			HStack {
				Spacer()
				Text("")
				Spacer()
			}
			.frame(width: 15, height: 15)
			.background(entry.isPlay ? Color.green.opacity(0.05) : Color.gray.opacity(0.05))
			.clipShape(Circle())
			HStack {
				Spacer()
				Text("")
					.font(Font.system(size: 8))
				Spacer()
			}
			.frame(width: 5, height: 5)
			.background(entry.isPlay ? Color.green.opacity(0.5) : Color.gray.opacity(0.5))
			.clipShape(Circle())
		}
    }
}

