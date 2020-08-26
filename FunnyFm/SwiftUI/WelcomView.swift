//
//  WelcomView.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/8/26.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct WelcomView: View {
    
    @State var showSheet: Bool = false
    @State var showPolicy: Bool = false
    @State var checkStatus: UIColor = R.color.mainRed()!
    
    var body: some View {
        VStack (alignment: .leading){
            Text("欢迎使用".localized)
                .font(.largeTitle)
                .bold()
                .padding(.vertical, 32.auto())
            Text ("FunnyFM")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color(R.color.mainRed()!))
                .padding(.bottom, 16.auto())
            VStack(alignment: .leading, spacing: 24.auto()){
                HStack{
                    Image("lemonade")
                        .resizable()
                        .frame(width: 50.auto(), height: 50.auto(), alignment: .center)
                    VStack(alignment: .leading, spacing: 8.auto()){
                        Text("轻量的播客工具".localized)
                            .font(.callout)
                            .bold()
                        Text("功能简单、体积小巧、 操作简洁".localized)
                            .font(.callout)
                    }
                    .padding(.leading, 12.auto())
                }
                HStack {
                    Image("network")
                        .resizable()
                        .frame(width: 50.auto(), height: 50.auto(), alignment: .center)
                    VStack (alignment: .leading, spacing: 8.auto()){
                        Text("多端同步".localized)
                            .font(.callout)
                            .bold()
                        Text("只要拥有账号，云端同步不是问题".localized)
                            .font(.callout)
                    }
                    .padding(.leading, 12.auto())
                }
                HStack {
                    Image("mask")
                        .resizable()
                        .frame(width: 50.auto(), height: 50.auto(), alignment: .center)
                    VStack(alignment: .leading, spacing: 8.auto()) {
                        Text("隐私第一".localized)
                            .font(.callout)
                            .bold()
                        Text("我们尊重您的隐私，不会上传或者与任何第三方分享您的私密数据".localized)
                            .font(.callout)
                    }
                    .padding(.leading, 12.auto())
                }
            }
            .padding(.bottom, 32.auto())
            .padding(.horizontal, 8.auto())
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.seal")
                        .font(.callout)
                        .foregroundColor(Color(checkStatus))
                        .onTapGesture {
                            if checkStatus == R.color.mainRed() {
                                checkStatus = R.color.content()!
                            }else {
                                checkStatus = R.color.mainRed()!
                            }
                        }
                    HStack{
                        Text("我已阅读并同意".localized)
                        Text("隐私政策".localized)
                            .onTapGesture {
                                showPolicy = true
                                showSheet = true
                            }
                        Text("和".localized)
                        Text("使用条款".localized)
                            .onTapGesture {
                                showPolicy = false
                                showSheet = true
                            }
                    }
                    .font(.caption)
                    .foregroundColor(Color(R.color.content()!))
                    .sheet(isPresented: $showSheet, onDismiss: {
                        showPolicy = false
                        showSheet = false
                    }, content: {
                        if showPolicy {
                            PolicyView()
                        }else{
                            TermView()
                        }
                    })
                    Spacer()
                }
            }
            VStack {
                NavigationLink(destination: BaseTabbarView()) {
                    HStack{
                        Spacer()
                        Text("开始使用")
                            .font(.footnote)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .clipShape(Capsule())
                    .background(Color(R.color.mainRed()!))
                    .frame(width: 120.auto(), height: 50.auto(), alignment: .center)
                    
                }
            }
            .padding(.top, 44.auto())
            Spacer()
        }.padding(.leading, 12.auto())
    }
}

struct WelcomView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomView()
    }
}
