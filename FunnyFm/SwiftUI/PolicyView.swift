//
//  PolicyTerm.swift
//  FunnyFm
//
//  Created by wt on 2020/5/19.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct PolicyView: View {
    var body: some View {
		List{
			VStack(alignment: HorizontalAlignment.leading, spacing: 10){
				Text("趣播客隐私策略").font(.headline)
				Divider()
				Text("我们尊重并保护您的个人隐私。本隐私策略解释趣播客收集的关于您的哪些信息及其原因，以及会如何使用和保护这些信息。").font(.caption)
				VStack(alignment: HorizontalAlignment.leading, spacing: 10){
					Text("趣播客会收集我的哪些信息？").font(.callout)
					Text("1、趣播客以匿名形式通过 Bugly 服务收集日常使用数据、崩溃日志。").font(.caption)
					Text("2、趣播客使用腾讯云服务同步用户数据。").font(.caption)
					Text("趣播客何保护我的隐私?").font(.callout)
					Text("1、趣播客不会在除 Bugly 与腾讯云以外的服务器存储数据。").font(.caption)
					Text("2、趣播客不会在除非您许可的情况下将您的个人信息分享给第三方。").font(.caption)
				}.padding(10)
			}.padding(20)
		}
    }
}

struct PolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PolicyView()
    }
}
