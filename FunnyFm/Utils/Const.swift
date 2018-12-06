//
//  Const.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import Foundation
import UIKit

// MARK: UI Adapt

func AdaptScale(_ w: CGFloat) -> CGFloat {
    let scale = kScreenWidth / 375.0
    return ( w * scale)
}

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
let kHMargin = AdaptScale(14)
let kVMargin = AdaptScale(12)




// MARK: Device

let kIOS9 = Double(UIDevice.current.systemVersion)! >= 9.0 ? 1 :0
let kIOS10 = Double(UIDevice.current.systemVersion)! >= 10.0 ? 1 :0
let kIOS11 = Double(UIDevice.current.systemVersion)! >= 11.0 ? 1 :0
let kIOS12 = Double(UIDevice.current.systemVersion)! >= 12.0 ? 1 :0



// MARK: Color
func RGB(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}

func RGBA(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat, _ a: CGFloat) -> UIColor{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
}


// 常用 color
public enum CommonColor {
    case title            // 标题颜色
    case subtitle         // 副标题颜色
    case background       // controller背景色
    case cellbackgroud    // cell 背景色
    
    public var color : UIColor {
        switch self {
        case .title:
            return RGB(114,123,136)
        case .subtitle:
            return RGB(202,202,202)
        case .background:
            return RGB(245,245,245)
        case .cellbackgroud:
            return RGB(250,250,250)
        }
    }
}





// MARK: Font

let fontsize0 : CGFloat = 10.0
let fontsize1 : CGFloat = 11.0
let fontsize2 : CGFloat = 12.0
let fontsize3 : CGFloat = 13.0
let fontsize4 : CGFloat = 14.0
let fontsize5 : CGFloat = 15.0
let fontsize6 : CGFloat = 16.0

func sFont(_ fontsize:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontsize)
}

func s_bFont(_ fontsize:CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: fontsize)
}

func pfont(_ fontsize:CGFloat) -> UIFont {
    return UIFont.init(name: "PingFangSC-Regular", size: fontsize)!
}

func p_mfont(_ fontsize:CGFloat) -> UIFont {
    return UIFont.init(name: "PingFangSC-Medium", size: fontsize)!
}

func p_bfont(_ fontsize:CGFloat) -> UIFont {
    return UIFont.init(name: "PingFangSC-Semibold", size: fontsize)!
}


extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
    
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}
