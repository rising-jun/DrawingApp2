//
//  Color.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/23.
//

import Foundation
import UIKit

struct Color {
    private(set) var r: UInt8
    private(set) var g: UInt8
    private(set) var b: UInt8
    
    var red: Double { return Double(self.r) / 255 }
    var green: Double { return Double(self.g) / 255 }
    var blue: Double { return Double(self.b) / 255 }
    
    var hexaColor: String {
        var string = "#"
        string += String(format:"%02X", r)
        string += String(format:"%02X", g)
        string += String(format:"%02X", b)
        return string
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
