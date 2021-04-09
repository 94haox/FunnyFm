//
//  SlideBar.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct SlideBar: View {
    var body: some View {
        List {
            HStack {
                Text("最新")
                Spacer()
            }
            Text("浏览")
            Text("个人中心")
        }
    }
}

struct SlideBar_Previews: PreviewProvider {
    static var previews: some View {
        SlideBar()
    }
}
