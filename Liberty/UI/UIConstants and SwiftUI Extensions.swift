//
//  UIConstants.swift
//  Liberty
//
//  Created by Alexey Ageev on 02.08.2022.
//

import SwiftUI


struct UIConstants {
    static let windowWidth: Double = 340
    static let windowHeight: Double = 570
}

extension Color {
    static let greenAccent: Color = Color(red: 25 / 255, green: 186 / 255, blue: 146 / 255)
    static let background: Color = {
        #if canImport(UIKit)
        return Color(uiColor: .systemBackground)
        #elseif canImport(AppKit)
        return Color(nsColor: .windowBackgroundColor)
        #else
        return .white
        #endif
    }()
}

/// All the font sizes were taken from https://gist.github.com/zacwest/916d31da5d03405809c4
extension Font {
    //FIXME: such font sizes seems to be too large for macOS
    static let exoTitle = Font.custom("Exo 2", size: 28, relativeTo: .title)
    static let exoTitle3 = Font.custom("Exo 2", size: 20, relativeTo: .title3)
    static let exoBody = Font.custom("Exo 2", size: 17, relativeTo: .body)
    static let exoCaption = Font.custom("Exo 2", size: 13, relativeTo: .caption)
}
