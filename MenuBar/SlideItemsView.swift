//
//  SlideItemsView.swift
//  MenuBar
//
//  Created by 吴涛 on 2020/9/16.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct MenuItemView: View {
    
    @Binding var selectedItem: FunnyMenu
    
    @State var isHover: Bool = false
    
    var item: FunnyMenu
    
    var body: some View {
        ZStack{
            HStack {
                Image(item.imageName())
                    .resizable()
                    .frame(width: 25, height: 25)
                    .accentColor(selectedItem == item ? Color.accentColor: .clear)
                Text(item.title())
                    .font(.callout)
                    .padding(.horizontal, 4)
                    .foregroundColor(selectedItem == item ? Color.accentColor: .black)
                Spacer()
            }
            .frame(width:110, height: 30)
            .padding(.leading, 18)
            .background(isHover ? Color.white.opacity(0.8) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius:8, style: .continuous))
            .onHover { (hovered) in
                isHover = hovered
            }
            if selectedItem == item {
                HStack{
                    VStack {
                        Text("s")
                            .foregroundColor(.clear)
                    }
                    .padding(.leading, 2)
                    .background(Color.accentColor)
                    .frame(width: 2, height: 25)
                    Spacer()
                }
            }
                 
        }
        .onTapGesture {
            selectedItem = item
        }
    }
}


struct SlideItemsView: View {
    
    @Binding var selected: FunnyMenu
    
    var body: some View {
        VStack {
            MenuItemView(selectedItem: $selected, item: FunnyMenu.now)
                .padding(.top, 36)
            MenuItemView(selectedItem: $selected, item: FunnyMenu.discovery)
            MenuItemView(selectedItem: $selected, item: FunnyMenu.playList)
            MenuItemView(selectedItem: $selected, item: FunnyMenu.user)
            Spacer()
        }
    }
}

