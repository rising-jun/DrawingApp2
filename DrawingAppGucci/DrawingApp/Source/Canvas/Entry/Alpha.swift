//
//  Alpha.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import Foundation
import UIKit

enum Alpha  {
    case one, two, three, four, five, six, seven, eight, nine, ten
    
    var value: Double {
        switch self {
        case .one:
            return 0.1
        case .two:
            return 0.2
        case .three:
            return 0.3
        case .four:
            return 0.4
        case .five:
            return 0.5
        case .six:
            return 0.6
        case .seven:
            return 0.7
        case .eight:
            return 0.8
        case .nine:
            return 0.9
        case .ten:
            return 1.0
        }
    }
    
    mutating func change(value: Double) {
        switch value {
        case 0.1..<0.2:
            self =  .one
        case 0.2..<0.3:
            self = .two
        case 0.3..<0.4:
            self = .three
        case 0.4..<0.5:
            self = .four
        case 0.5..<0.6:
            self = .five
        case 0.6..<0.7:
            self = .six
        case 0.7..<0.8:
            self = .seven
        case 0.8..<0.9:
            self = .eight
        case 0.9..<1.0:
            self = .nine
        default:
            self = .ten
        }
    }
}


