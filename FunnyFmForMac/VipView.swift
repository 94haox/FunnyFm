//
//  VipView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/12.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct VipView: View {
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Image("pro_ads")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 12)
                }
                Spacer()
            }
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: "bag.fill")
                        .padding(.trailing, 2)
                    Text("解锁 Pro 功能")
                    Spacer()
                }
                .font(.largeTitle)
                .foregroundColor(.yellow)
                .padding(.horizontal, 32)
                .padding(.vertical, 32)
                HStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image("category")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("全部功能解锁，无限制使用")
                                .bold()
                        }
                        HStack {
                            Image("cloud-sync")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("多平台，多设备数据同步")
                                .bold()
                        }
                        HStack {
                            Image("adblock")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("全功能去除广告")
                                .bold()
                        }
                        HStack {
                            Image("VIP")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("更多专属 Pro 用户的实用功能")
                                .bold()
                        }
                    }
                    .font(.headline)
                    Spacer()
                }
                .padding(.vertical, 32)
                HStack (spacing: 12) {
                    Spacer()
                    PlainButton(text: "￥3/月", action: {
                        
                    })
                    .frame(width: 100, height: 45, alignment: .center)
                    .background(Color.accentColor)
                    .cornerRadius(8)
                    
                    PlainButton(text: "￥18/年", action: {
                        
                    })
                    .frame(width: 100, height: 45, alignment: .center)
                    .background(Color.accentColor)
                    .cornerRadius(8)
                    
                    PlainButton(text: "￥32/永久", action: {
                        
                    })
                    .frame(width: 100, height: 45, alignment: .center)
                    .background(Color.accentColor)
                    .cornerRadius(8)
                    Spacer()
                }
                .padding(.top, 32)
                .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 6)
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

struct VipView_Previews: PreviewProvider {
    static var previews: some View {
        VipView()
    }
}
