//
//  PolicyTerm.swift
//  FunnyFm
//
//  Created by wt on 2020/5/19.
//  Copyright © 2020 Duke. All rights reserved.
//

import SwiftUI

struct PolicyTerm: View {
    var body: some View {
        VStack {
            VStack {
                Text("Policy")
                    .font(.headline)
                Text("")
                    .font(.caption)
            }
            Spacer()
            VStack {
                Text("Term")
                    .font(.headline)
            }
        }
    }
}

struct PolicyTerm_Previews: PreviewProvider {
    static var previews: some View {
        PolicyTerm()
    }
}
