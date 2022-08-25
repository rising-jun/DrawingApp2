//
//  Color.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/23.
//

import Foundation
import UIKit

@propertyWrapper
struct Fracktion {
    private var value: UInt8 = 0
    private(set) var projectedValue: Double = 0.0
    
    var wrappedValue: UInt8 {
        get {
            return value
        }
        set {
            self.value = newValue
            self.projectedValue = Double(newValue) / 255
        }
    }
    
    init(wrappedValue initalValue: UInt8) {
        self.wrappedValue = initalValue
    }
}

struct Color {
    
    @Fracktion private(set) var r: UInt8
    @Fracktion private(set) var g: UInt8
    @Fracktion private(set) var b: UInt8
    
    var hexaColor: String {
        var s = "#"
        [r,g,b].forEach { s += String(format: "%02X", $0) }
        return s
    }

    init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }
    
    init() {
        self.init(r: 0, g: 0, b: 0)
        self.setRandomColor()
    }
    
    mutating func setRandomColor() {
        r = UInt8.random(in: (UInt8.min...UInt8.max))
        g = UInt8.random(in: (UInt8.min...UInt8.max))
        b = UInt8.random(in: (UInt8.min...UInt8.max))
    }
}
