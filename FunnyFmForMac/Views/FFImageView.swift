//
//  FFImageView.swift
//  FunnyFmForMac
//
//  Created by 吴涛 on 2021/4/10.
//  Copyright © 2021 Duke. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct FFImageView: View {
    
    private let imageUrl: URL?
    
    private var placeHolder: Image = Image(systemName: "bolt.slash.fill")
    
    init(urlString: String,
         imageHolderName: String? = nil) {
        imageUrl = URL(string: urlString)
        if let holder = imageHolderName {
            placeHolder = Image(holder)
        }
    }
        
    var body: some View {
        WebImage(url: imageUrl)
        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
        .onSuccess { image, data, cacheType in
            // Success
            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
        }
        .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
//        .placeholder(placeHolder) // Placeholder Image
        // Supports ViewBuilder as well
        .placeholder {
            ZStack {
                Rectangle().foregroundColor(Color.gray.opacity(0.4))
                placeHolder
                    .frame(width: 10, height: 10, alignment: .center)
            }
        }
        .indicator(.activity) // Activity Indicator
        .transition(.fade(duration: 0.5)) // Fade Transition with duration
        .scaledToFill()
    }
}
