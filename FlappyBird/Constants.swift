//
//  Constants.swift
//  FlappyBird
//
//  Created by sujin on 5/16/24.
//

import Foundation


struct Layer {
    static let sky: CGFloat = 1
    static let pipe: CGFloat = 2
    static let land: CGFloat = 3
    static let ceil: CGFloat = 4
    static let bird : CGFloat = 5
}

// physics category object
// 값이 겹치지 않도록 하는 것이 중요
struct  PhysicsCategory{
    // 1
    static let bird: UInt32 = 0x1 << 0
    // 2
    static let land: UInt32 = 0x1 << 1
    // 4
    static let ceil: UInt32 = 0x1 << 2
    // 8
    static let pipe: UInt32 = 0x1 << 3
    // 16
    static let score: UInt32 = 0x1 << 4
    
}
