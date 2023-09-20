//
//  ColorPalette.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 17/09/2023.
//

import UIKit

struct ColorPalette {
    // MARK: - Colors by name

    // App Palette
    // {"Rose quartz":"bcabae","Night":"0f0f0f","Jet":"2d2e2e","Dim gray":"716969","White":"fbfbfb"}
    private static let roseQuartz = UIColor(hex: 0xbcabae)
    private static let night = UIColor(hex: 0x0f0f0f)
    private static let jet = UIColor(hex: 0x2d2e2e)
    private static let dimGray = UIColor(hex: 0x716969)
    private static let white = UIColor(hex: 0xfbfbfb)
    private static let pureWhite = UIColor(hex: 0xfbfbfb)
    
    // RickAndMorty Palette
    // {"Penn Blue":"111440","Mantis":"82bf45","Arylide yellow":"f2dd72","Orange (wheel)":"f28322","Melon":"f2b199"}
    private static let pennBlue = UIColor(hex: 0x111440)
    private static let mantis = UIColor(hex: 0x82bf45)
    private static let arylideYellow = UIColor(hex: 0xf2dd72)
    private static let orangeWheel = UIColor(hex: 0xf28322)
    private static let melon = UIColor(hex: 0xf2b199)
    
    // MARK: - Colors by role
    static let background = white
    static let backButton = jet
    static let characterBackgroundCell = jet
    static let tint = pureWhite
    static let subtitle = white
    static let humanSpecie = roseQuartz
    static let alienSpecie = mantis
    static let favoriteCellActionBackground = dimGray
    static let favoriteHeart = orangeWheel
    static let characterStatusAlive = mantis
    static let characterStatusDead = orangeWheel
    static let characterStatusUnknown = dimGray
    static let characterOriginArrow = orangeWheel
    static let characterOriginArrowUnknown = dimGray
    static let characterLocationViewFinder = mantis
    static let characterLocationArrow = orangeWheel
}

// MARK: - UIColor from hex

extension UIColor {
    convenience init(hex: Int) {
        let red = CGFloat((hex >> 16) & 0xff) / 255
        let green = CGFloat((hex >> 8) & 0xff) / 255
        let blue = CGFloat(hex & 0xff) / 255
        let alpha: CGFloat = 1
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hexString: String) {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            self.init(white: 0.2, alpha: 1.0)
        } else {
            var rgbValue: UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xff0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00ff00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000ff) / 255.0,
                      alpha: CGFloat(1.0))
        }
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb = Int(r*255)<<16 | Int(g*255)<<8 | Int(b*255)<<0
        
        return String(format: "#%06x", rgb)
    }
    
    static func == (l: UIColor, r: UIColor) -> Bool {
        var l_red = CGFloat(0); var l_green = CGFloat(0); var l_blue = CGFloat(0); var l_alpha = CGFloat(0)
        guard l.getRed(&l_red, green: &l_green, blue: &l_blue, alpha: &l_alpha) else { return false }
        var r_red = CGFloat(0); var r_green = CGFloat(0); var r_blue = CGFloat(0); var r_alpha = CGFloat(0)
        guard r.getRed(&r_red, green: &r_green, blue: &r_blue, alpha: &r_alpha) else { return false }
        return l_red == r_red && l_green == r_green && l_blue == r_blue && l_alpha == r_alpha
    }
}
