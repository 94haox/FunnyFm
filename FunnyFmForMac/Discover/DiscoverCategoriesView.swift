//
//  DiscoverCategoriesView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/23.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct DiscoverCategoriesView: View {
    
    @Binding var selection: String?
    
    var body: some View {
        HStack {
            VStack {
                Text("Categories")
                    .bold()
                    .font(.largeTitle)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: Array(repeating: .init(.flexible()), count: 1), spacing: 6) {
                        ForEach(Category.all, id: \.self) { item in
                            CategoryItemView(category: item)
                                .frame(minWidth: 120,  minHeight: 50)
                                .cornerRadius(5)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct CategoryItemView: View {
    
    let category: Category
    
    @State var isHover: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Image(category.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(category.name)
                    .padding(.trailing, 8)
            }
            .padding(.all, 4)
            Spacer()
        }
        .onHover { isHover in
            self.isHover = isHover
        }
        .foregroundColor(.white)
        .background(self.isHover ? Color.accentColor : Color.gray)
    }
}
