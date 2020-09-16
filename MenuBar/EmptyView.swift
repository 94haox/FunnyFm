//
//  EmptyView.swift
//  MenuBar
//
//  Created by Tao on 2020/9/2.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct EmptyView: View {
    var body: some View {
        VStack {
            KFImage(gifPath())
                .resizable()
                .frame(width: 200, height: 200)
            Text("您好像还没开始收听")
        }
    }
    
    func gifPath() -> URL {
        let path = Bundle.main.path(forResource:"empty", ofType:"gif")
        let url = URL(fileURLWithPath: path!)
        return url
    }
    
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
