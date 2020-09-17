//
//  SubscribtionView.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/5/21.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct SubscribtionView: View {
    var body: some View {
		List {
			VStack(alignment: .leading, spacing: 20){
				Text("趣播客 Pro").font(.headline)
				Divider()
				Text("趣播客Pro是一项付费订阅服务。可以在「Pro」处找到该功能。").font(.caption)
				Text("订阅该服务即可成为趣播客Pro用户，在订阅周期内无限制使用全部功能，包含未来新增的功能。").font(.caption)
				Text("关于此项服务的订阅相关细则:").font(.caption)
				VStack(alignment: .leading, spacing: 10) {
					Text("该服务目前支持以3元/月和18元/年进行订阅，在活动期间可能会以优惠价促销，或者提供免费试用，试用以后将无法取消当期订阅。")
					Text("·费用将在确认购买后、免费试用期结束时正式开始从 iTunes 帐户扣除")
					Text("·订阅是自动续期的服务，若不打算续期，请在当前计费周期结束前至少24小时手动关闭")
					Text("·续期的费用将在当前周期结束前的24小时内扣除")
					Text("·在订阅该服务后，可以在 App Store的账户设置里提供的「订阅」入口进入以管理订阅续费等操作")
					Text("·在免费试用期间，任何未使用天数，将在用户购买该服务后被没收。")
				}
				.font(.caption)
				.padding(10)
			}.padding(30)
		}
	}
}

struct SubscribtionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscribtionView()
    }
}
