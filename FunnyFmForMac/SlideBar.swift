//
//  SlideBar.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct SlideBar: View {
    
    @EnvironmentObject private var uiState: UIState
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            HStack {
                Image("logo-white")
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .center)
                    .cornerRadius(5)
                    .shadow(color: Color.gray.opacity(0.4), radius: 12, x: 0, y: 0)
                    .padding(.trailing, 4)
                Text("趣播客")
                    .bold()
                Spacer()
            }
            .padding(.leading, 12)
            .padding(.vertical, 12)
            List (selection: $uiState.sidebarSelection) {
                Group{
                    ForEach(UIState.DefaultChannels.allCases, id: \.self) { item in
                        NavigationLink(
                            destination: MainContentView(channel: item),
                            label: {
                                SlideItemView(title: item.rawValue,
                                              iconName: item.icon())
                            })
                        .tag(item.rawValue)
                        .frame(width: 200, height: 30, alignment: .leading)
                        .padding(.bottom, 4)
                    }
                }
                .listItemTint(.accentColor)
            }
            .listStyle(SidebarListStyle())
            Spacer()
            VipIntroView()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.gray.opacity(0.4), radius: 12, x: 0, y: 0)
                .padding(.bottom, 10)
        }
        .frame(minWidth: 180, idealWidth: 180, maxHeight: .infinity)
    }
}

struct SlideBar_Previews: PreviewProvider {
    static var previews: some View {
        SlideBar()
    }
}
