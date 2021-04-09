//
//  DashboradView.swift
//  FunnyFm
//
//  Created by 吴涛 on 2021/4/9.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI

struct DashboradView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var user: UserCenter = UserCenter.shared
    
    var body: some View {
        if user.isLogin {
            ZStack {
                NavigationView {
                    SlideBar()
                        .frame(width: 100)
                        .fixedSize(horizontal: true, vertical: false)
                    MainContentView()
                        .environment(\.managedObjectContext, viewContext)
                }
                .background(Color.white)
                .toolbar {
                    Spacer()
                    Button(action: {}) {
                        Label("Add Item", systemImage: "magnifyingglass.circle.fill")
                    }
                }
                VStack {
                    Spacer()
                    PlayBarView()
                        .frame(height: 80)
                        .padding(.bottom, 0)
                        .background(Color.white)
                }
            }
        } else {
            LoginView()
                .frame(width: 500, height: 400, alignment: .center)
                .background(Color.white)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

struct DashBoradView_Previews: PreviewProvider {
    static var previews: some View {
        DashboradView()
    }
}
