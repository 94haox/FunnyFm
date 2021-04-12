//
//  VipView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct VipIntroView: View {
    
    @State private var isSheet: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Image("pro_ads")
                        .resizable()
                        .frame(width: 90, height: 80)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 12)
                }
                Spacer()
            }
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Image(systemName: "bag.fill")
                        Text("解锁 Pro 功能")
                    }
                    Spacer()
                }
                .font(.headline)
                .foregroundColor(.yellow)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
            }
            .onTapGesture {
                isSheet = true
            }
        }
        .sheet(isPresented: $isSheet) {
            VipView()
                .toolbar {
                    Label("确认", systemImage: "xmark.circle")
                        .onTapGesture(perform: close)
                }
        }
        .frame(minWidth: 160, idealWidth: 160, maxWidth: 160, minHeight: 110, idealHeight: 110, maxHeight: 110, alignment: .center)
    }
    
    func close() {
        isSheet = false
    }
}
