//
//  Id.swift
//  DrawingApp2
//
//  Created by 김동준 on 2022/07/11.
//

final class Id {
    var id: String
    init(id: String) {
        self.id = id
    }
    static func makeId() -> Id {
        let strings = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let length = 3
        var id: String = ""
        for count in 0 ..< 3 {
            let randomString = (0 ..< length).map{ _ in strings.randomElement() }.compactMap { $0 }
            count == 2 ? id.append(String(randomString)) : id.append("\(String(randomString))-")
        }
        return Id(id: id)
    }
}
extension Id: CustomStringConvertible {
    var description: String {
        "id : (\(id))"
    }
}
