//
//  ColorsHelper.swift
//  GivBit
//
//  Created by Tallal Javed on 5/9/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class ColorsHelper: NSObject {
    
    static let loginViewColor1 = UIColor(hexString: "#14dcf8")
    static let loginViewColor2 = UIColor(hexString: "#5348d0")
    static let barTintColor1 = UIColor(hexString: "#696cff")
    
    static let generalBlueColor = UIColor(hexString: "#6970F6")
    
    
    // Returns background color for UIView
    static func getLoginViewBackgroundGradientColor(rect: CGRect)-> UIColor{
        return UIColor(gradientStyle: .topToBottom, withFrame: rect, andColors: [self.loginViewColor1!, self.loginViewColor2!])
    }
    
    static func setTheme1(){
        setTabBarAppearence(theme: 1)
    }
    
    static func setTabBarAppearence(theme: Int){
        if theme == 1{
            UITabBar.appearance().tintColor = barTintColor1
        }
    }
}
